import 'package:flutter/material.dart';
import 'package:proflight/core/error/error_presentation.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/auth_user.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';

class RegisterScreenModel extends ChangeNotifier {
  RegisterScreenModel(this._authService);

  final AuthRepository _authService;

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

    final result = await _authService.signUp(
      email: emailController.text,
      password: passwordController.text,
      profileName: boardController.text,
      fio: nameController.text,
      company: companyController.text,
    );

    if (result is Err<AuthUser>) {
      _errorMessage = result.error.userMessage;
      notifyListeners();
      return false;
    }

    return true;
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
