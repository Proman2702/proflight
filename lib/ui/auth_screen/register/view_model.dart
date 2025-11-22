import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class RegisterScreenModel extends ChangeNotifier {
  String _email = "";
  String _password = "";

  final AuthService _authService = AuthService();

  String get email => _email;
  String get password => _password;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void _registerUser() async {
    await _authService.signIn(_email, _password);
  }

  void leaveWithRegister(BuildContext context) {
    _registerUser();
    Navigator.pop(context);
  }
}
