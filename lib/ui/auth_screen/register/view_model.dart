import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class RegisterScreenModel extends ChangeNotifier {
  String _email = "";
  String _password = "";
  bool _inProcess = false;
  String? _errorMessage;

  final AuthService _authService;

  RegisterScreenModel(this._authService);

  String get email => _email;
  String get password => _password;
  String? get errorMessage => _errorMessage;
  bool get inProcess => _inProcess;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<bool> registerUser() async {
    _errorMessage = null;

    try {
      final user = await _authService.signUp(_email, _password);

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
}
