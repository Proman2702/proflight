import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class AuthScreenModel extends ChangeNotifier {
  final AuthService _authService;
  String _email = "";
  String _password = "";
  bool _inProcess = false;
  String? _errorMessage;

  String get email => _email;
  String get password => _password;
  String? get errorMessage => _errorMessage;
  bool get inProcess => _inProcess;

  AuthScreenModel(this._authService);

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<bool> signInUser() async {
    _errorMessage = null;

    try {
      final user = await _authService.signIn(_email, _password);

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
}
