import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

// class _RegisterScreenModelState {
//   final int step;
//   final String? errorMessage;
//   final bool isLoading;

//     _RegisterScreenModelState({
//       required this.step,
//       required this.errorMessage,
//       required this.isLoading
//     });

//     const _RegisterScreenModelState.initial()
//     : step = 0,
//       errorMessage = null,
//       isLoading = false;

//   _RegisterScreenModelState copyWith({
//     int? step,
//     String? errorMessage,
//     bool? isLoading
//   }) {
//     return _RegisterScreenModelState(
//       step: step ?? this.step,
//       errorMessage: errorMessage,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }

// }

class RegisterScreenModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final boardController = TextEditingController();
  final companyController = TextEditingController();
  final totalHoursController = TextEditingController();
  final totalHours1Controller = TextEditingController();
  final totalHours2Controller = TextEditingController();

  String? _errorMessage;

  int _step = 0;

  final AuthService _authService;

  RegisterScreenModel(this._authService);

  int get step => _step;
  String? get errorMessage => _errorMessage;

  void stepIncrement() {
    if (_step < 2) _step++;
    notifyListeners();
  }

  void stepDecrement() {
    if (step > 0) _step--;
    notifyListeners();
  }

  void setStep(int value) {
    _step = value;
    notifyListeners();
  }

  bool allowRegister() => _step >= 2;

  Future<bool> registerUser() async {
    _errorMessage = null;

    try {
      final user = await _authService.signUp(emailController.text, passwordController.text);

      if (user == null) {
        _errorMessage = "Ошибка регистрации";
        notifyListeners();
        return false;
      }

      return true; // успех
    } catch (e) {
      _errorMessage = e.toString(); // тут можно мапить в красивый текст
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();

    passwordController.dispose();
    nameController.dispose();
    boardController.dispose();
    companyController.dispose();
    totalHoursController.dispose();
    totalHours1Controller.dispose();
    totalHours2Controller.dispose();
    super.dispose();
  }
}
