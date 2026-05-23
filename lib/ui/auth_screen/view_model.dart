import 'package:flutter/material.dart';
import 'package:proflight/core/error/error_presentation.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/auth_user.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';

class AuthScreenModel extends ChangeNotifier {
  AuthScreenModel(this._authService);

  final AuthRepository _authService;

  bool _inProcess = false;
  String? _errorMessage;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? get errorMessage => _errorMessage;
  bool get inProcess => _inProcess;

  Future<bool> signInUser() async {
    _errorMessage = null;
    _inProcess = true;
    notifyListeners();

    final result = await _authService.signIn(
      email: emailController.text,
      password: passwordController.text,
    );

    _inProcess = false;
    if (result is Err<AuthUser>) {
      _errorMessage = result.error.userMessage;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
