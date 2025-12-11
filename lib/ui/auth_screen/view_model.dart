import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class AuthScreenModel extends ChangeNotifier {
  final AuthService _authService;

  bool _inProcess = false;
  String? _errorMessage;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? get errorMessage => _errorMessage;
  bool get inProcess => _inProcess;

  AuthScreenModel(this._authService);

  Future<bool> signInUser() async {
    _errorMessage = null;

    try {
      final user = await _authService.signIn(emailController.text, passwordController.text);

      if (user == null) {
        _errorMessage = "Ошибка авторизации";
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
    super.dispose();
  }
}
