import 'package:flutter/material.dart';
import 'package:proflight/core/error/failure.dart';
import 'package:proflight/core/error/failures.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/pilot_profile.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._authRepository, this._databaseRepository);

  final AuthRepository _authRepository;
  final AppDatabaseRepository _databaseRepository;

  bool isLoading = false;
  PilotProfile? profile;
  Failure? _failure;

  String? get email => _authRepository.currentUser?.email;

  final fioController = TextEditingController();
  final companyController = TextEditingController();
  final addAllController = TextEditingController();
  final addDayController = TextEditingController();
  final addNightController = TextEditingController();

  String get airportCodeFormat => profile?.airportCodeFormat ?? 'IATA';

  Failure? takeFailure() {
    final failure = _failure;
    _failure = null;
    return failure;
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    final result = await _databaseRepository.listProfiles();
    if (result is Err<List<PilotProfile>>) {
      _failure = result.error;
    } else {
      final profiles = (result as Ok<List<PilotProfile>>).value;
      profile = profiles.isEmpty ? null : profiles.first;
      _fill(profile);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Result<PilotProfile>> save() async {
    final current = profile;
    if (current == null) {
      return Err(
        DatabaseFailure(
          DatabaseFailureType.notFound,
          message: 'Профиль не найден',
        ),
      );
    }

    final next = PilotProfile(
      profileName: current.profileName,
      fio: fioController.text.trim(),
      company: companyController.text.trim().isEmpty
          ? null
          : companyController.text.trim(),
      flytimeAll: current.flytimeAll,
      flytimeDay: current.flytimeDay,
      flytimeNight: current.flytimeNight,
      addAll: int.tryParse(addAllController.text.trim()) ?? current.addAll,
      addDay: int.tryParse(addDayController.text.trim()) ?? current.addDay,
      addNight:
          int.tryParse(addNightController.text.trim()) ?? current.addNight,
      airportCodeFormat: current.airportCodeFormat,
    );
    final result = await _databaseRepository.replaceProfile(next);
    if (result is Ok<PilotProfile>) {
      profile = result.value;
      _fill(profile);
      notifyListeners();
    }
    return result;
  }

  Future<Result<PilotProfile>> saveAirportCodeFormat(String value) async {
    final current = profile;
    if (current == null) {
      return Err(
        DatabaseFailure(
          DatabaseFailureType.notFound,
          message: 'Профиль не найден',
        ),
      );
    }

    final next = PilotProfile(
      profileName: current.profileName,
      fio: current.fio,
      company: current.company,
      flytimeAll: current.flytimeAll,
      flytimeDay: current.flytimeDay,
      flytimeNight: current.flytimeNight,
      addAll: current.addAll,
      addDay: current.addDay,
      addNight: current.addNight,
      airportCodeFormat: value,
    );
    final result = await _databaseRepository.replaceProfile(next);
    if (result is Ok<PilotProfile>) {
      profile = result.value;
      _fill(profile);
      notifyListeners();
    }
    return result;
  }

  Future<Result<Unit>> signOut() => _authRepository.signOut();

  void _fill(PilotProfile? value) {
    fioController.text = value?.fio ?? '';
    companyController.text = value?.company ?? '';
    addAllController.text = (value?.addAll ?? 0).toString();
    addDayController.text = (value?.addDay ?? 0).toString();
    addNightController.text = (value?.addNight ?? 0).toString();
  }

  @override
  void dispose() {
    fioController.dispose();
    companyController.dispose();
    addAllController.dispose();
    addDayController.dispose();
    addNightController.dispose();
    super.dispose();
  }
}
