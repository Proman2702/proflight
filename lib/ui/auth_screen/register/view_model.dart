import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class RegisterScreenModel extends ChangeNotifier {
  String? _email;
  String? _password;

  final AuthService _authService = AuthService();

  void registerUser() async {
    await _authService.signIn(_email!, _password!);
  }
}
