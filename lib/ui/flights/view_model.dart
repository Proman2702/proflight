import 'package:flutter/material.dart';
import 'package:proflight/core/error/failure.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:proflight/ui/common/flight_formatters.dart';

class FlightsViewModel extends ChangeNotifier {
  FlightsViewModel(this._repository);

  final AppDatabaseRepository _repository;

  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
  PilotProfile? profile;
  List<FlightData> flights = const [];
  Failure? _failure;

  Failure? takeFailure() {
    final failure = _failure;
    _failure = null;
    return failure;
  }

  List<FlightData> get selectedDayFlights {
    final selected = FlightFormatters.apiDate(selectedDate);
    return flights
        .where((flight) => flight.flightDate == selected)
        .toList(growable: false);
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    final profilesResult = await _repository.listProfiles();
    if (profilesResult is Err<List<PilotProfile>>) {
      _failure = profilesResult.error;
      isLoading = false;
      notifyListeners();
      return;
    }

    final profiles = (profilesResult as Ok<List<PilotProfile>>).value;
    profile = profiles.isEmpty ? null : profiles.first;

    if (profile == null) {
      flights = const [];
      isLoading = false;
      notifyListeners();
      return;
    }

    final flightsResult = await _repository.listFlightDataByProfile(
      profile!.profileName,
    );
    if (flightsResult is Err<List<FlightData>>) {
      _failure = flightsResult.error;
      flights = const [];
    } else {
      flights = (flightsResult as Ok<List<FlightData>>).value;
      flights = [...flights]
        ..sort((a, b) => b.flightDate.compareTo(a.flightDate));
    }

    isLoading = false;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }
}
