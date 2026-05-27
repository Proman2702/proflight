import 'package:flutter/material.dart';
import 'package:proflight/core/error/failure.dart';
import 'package:proflight/core/error/failures.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/flight_data.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:proflight/ui/common/flight_formatters.dart';

class FlightEditViewModel extends ChangeNotifier {
  FlightEditViewModel(this._repository, this.flightId);

  final AppDatabaseRepository _repository;
  final int? flightId;

  bool isLoading = false;
  bool isSaving = false;
  PilotProfile? profile;
  Failure? _failure;

  final flightDateController = TextEditingController();
  final numberController = TextEditingController();
  final planeNumberController = TextEditingController();
  final flightController = TextEditingController();
  final placeDepartureController = TextEditingController();
  final placeArrivalController = TextEditingController();
  final placeArrival2Controller = TextEditingController();
  final timeOnController = TextEditingController();
  final timeOffController = TextEditingController();
  final timeDepartureController = TextEditingController();
  final timeArrivalController = TextEditingController();
  final timePvpController = TextEditingController();
  final timePppController = TextEditingController();
  final etdController = TextEditingController();
  final etaController = TextEditingController();
  final timeAllController = TextEditingController();
  final timeAirController = TextEditingController();
  final timeDayController = TextEditingController();
  final timeNightController = TextEditingController();
  final timePvpPppAllController = TextEditingController();
  final etdEtaAllController = TextEditingController();

  bool get isEditMode => flightId != null;

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
    flightDateController.text = FlightFormatters.apiDate(DateTime.now());

    if (flightId != null) {
      final result = await _repository.getFlightData(flightId!);
      if (result is Err<FlightData>) {
        _failure = result.error;
      } else {
        _fill((result as Ok<FlightData>).value);
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Result<FlightData>> save() async {
    final validation = _validate();
    if (validation != null) return Err(validation);

    isSaving = true;
    notifyListeners();

    final flight = _buildFlight();
    final result = isEditMode
        ? await _repository.replaceFlightData(flight)
        : await _repository.createFlightData(
            profileName: profile?.profileName ?? '',
            flightData: flight,
          );

    isSaving = false;
    notifyListeners();
    return result;
  }

  Future<Result<Unit>> delete() async {
    final id = flightId;
    if (id == null) {
      return Err(
        DatabaseFailure(
          DatabaseFailureType.invalidArgument,
          message: 'Нет полета для удаления',
        ),
      );
    }
    return _repository.deleteFlightData(id);
  }

  Failure? _validate() {
    if (flightDateController.text.trim().isEmpty) {
      return DatabaseFailure(
        DatabaseFailureType.invalidArgument,
        message: 'Укажите дату полета',
      );
    }
    if (int.tryParse(numberController.text.trim()) == null) {
      return DatabaseFailure(
        DatabaseFailureType.invalidArgument,
        message: 'Укажите номер строки',
      );
    }
    if (!RegExp(
      r'^\d{4}-\d{2}-\d{2}$',
    ).hasMatch(flightDateController.text.trim())) {
      return DatabaseFailure(
        DatabaseFailureType.invalidArgument,
        message: 'Дата должна быть YYYY-MM-DD',
      );
    }
    return null;
  }

  FlightData _buildFlight() {
    return FlightData(
      id: flightId,
      flightDate: flightDateController.text.trim(),
      number: int.parse(numberController.text.trim()),
      planeNumber: _text(planeNumberController),
      flight: _text(flightController),
      placeDeparture: _text(placeDepartureController),
      placeArrival: _text(placeArrivalController),
      placeArrival2: _text(placeArrival2Controller),
      timeOn: _text(timeOnController),
      timeOff: _text(timeOffController),
      timeDeparture: _text(timeDepartureController),
      timeArrival: _text(timeArrivalController),
      timePvp: _text(timePvpController),
      timePpp: _text(timePppController),
      etd: _text(etdController),
      eta: _text(etaController),
      timeAll: _text(timeAllController),
      timeAir: _text(timeAirController),
      timeDay: _text(timeDayController),
      timeNight: _text(timeNightController),
      timePvpPppAll: _text(timePvpPppAllController),
      etdEtaAll: _text(etdEtaAllController),
    );
  }

  String? _text(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void _fill(FlightData flight) {
    flightDateController.text = flight.flightDate;
    numberController.text = flight.number.toString();
    planeNumberController.text = flight.planeNumber ?? '';
    flightController.text = flight.flight ?? '';
    placeDepartureController.text = flight.placeDeparture ?? '';
    placeArrivalController.text = flight.placeArrival ?? '';
    placeArrival2Controller.text = flight.placeArrival2 ?? '';
    timeOnController.text = flight.timeOn ?? '';
    timeOffController.text = flight.timeOff ?? '';
    timeDepartureController.text = flight.timeDeparture ?? '';
    timeArrivalController.text = flight.timeArrival ?? '';
    timePvpController.text = flight.timePvp ?? '';
    timePppController.text = flight.timePpp ?? '';
    etdController.text = flight.etd ?? '';
    etaController.text = flight.eta ?? '';
    timeAllController.text = flight.timeAll ?? '';
    timeAirController.text = flight.timeAir ?? '';
    timeDayController.text = flight.timeDay ?? '';
    timeNightController.text = flight.timeNight ?? '';
    timePvpPppAllController.text = flight.timePvpPppAll ?? '';
    etdEtaAllController.text = flight.etdEtaAll ?? '';
  }

  @override
  void dispose() {
    flightDateController.dispose();
    numberController.dispose();
    planeNumberController.dispose();
    flightController.dispose();
    placeDepartureController.dispose();
    placeArrivalController.dispose();
    placeArrival2Controller.dispose();
    timeOnController.dispose();
    timeOffController.dispose();
    timeDepartureController.dispose();
    timeArrivalController.dispose();
    timePvpController.dispose();
    timePppController.dispose();
    etdController.dispose();
    etaController.dispose();
    timeAllController.dispose();
    timeAirController.dispose();
    timeDayController.dispose();
    timeNightController.dispose();
    timePvpPppAllController.dispose();
    etdEtaAllController.dispose();
    super.dispose();
  }
}
