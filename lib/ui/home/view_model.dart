import 'package:flutter/material.dart';
import 'package:proflight/core/error/failure.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:proflight/ui/common/flight_formatters.dart';
import 'package:proflight/ui/common/flight_stats.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository);

  final AppDatabaseRepository _repository;

  bool isLoading = false;
  PilotProfile? profile;
  List<FlightData> flights = const [];
  Failure? _failure;

  Failure? takeFailure() {
    final failure = _failure;
    _failure = null;
    return failure;
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
    }

    isLoading = false;
    notifyListeners();
  }

  FlightStats get totalStats => FlightStats.fromFlights(flights);
  FlightStats get todayStats =>
      FlightStats.fromFlights(_periodFlights(_isToday));
  FlightStats get weekStats =>
      FlightStats.fromFlights(_periodFlights(_isThisWeek));
  FlightStats get monthStats =>
      FlightStats.fromFlights(_periodFlights(_isThisMonth));
  FlightStats get yearStats =>
      FlightStats.fromFlights(_periodFlights(_isThisYear));

  List<FlightData> _periodFlights(bool Function(DateTime date) filter) {
    return flights
        .where((flight) {
          final date = FlightFormatters.parseApiDate(flight.flightDate);
          return date != null && filter(date);
        })
        .toList(growable: false);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isThisWeek(DateTime date) {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 7));
    return !date.isBefore(start) && date.isBefore(end);
  }

  bool _isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  bool _isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }
}
