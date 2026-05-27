import 'package:flutter/material.dart';
import 'package:proflight/core/error/failure.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:proflight/ui/common/flight_formatters.dart';
import 'package:proflight/ui/common/flight_stats.dart';

class ExportViewModel extends ChangeNotifier {
  ExportViewModel(this._repository);

  final AppDatabaseRepository _repository;

  bool isLoading = false;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  List<FlightData> flights = const [];
  PilotProfile? profile;
  Failure? _failure;

  Failure? takeFailure() {
    final failure = _failure;
    _failure = null;
    return failure;
  }

  FlightStats get stats => FlightStats.fromFlights(_rangeFlights);

  List<FlightData> get _rangeFlights {
    return flights
        .where((flight) {
          final date = FlightFormatters.parseApiDate(flight.flightDate);
          if (date == null) return false;
          final from = DateTime(startDate.year, startDate.month, startDate.day);
          final to = DateTime(endDate.year, endDate.month, endDate.day + 1);
          return !date.isBefore(from) && date.isBefore(to);
        })
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
    } else {
      flights = (flightsResult as Ok<List<FlightData>>).value;
    }

    isLoading = false;
    notifyListeners();
  }
}
