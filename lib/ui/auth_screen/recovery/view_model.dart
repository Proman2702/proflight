import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class RecoveryScreenModel extends ChangeNotifier {
  String _email = "";
  String? _errorMessage;

  final AuthService _authService;

  RecoveryScreenModel(this._authService);

  String get email => _email;
  String? get errorMessage => _errorMessage;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  Future<bool> sendVerification() async {
    _errorMessage = null;

    try {
      await _authService.sendPasswordReset(_email);

      return true; // успех
    } catch (e) {
      _errorMessage = e.toString(); // тут можно мапить в красивый текст
      notifyListeners();
      return false;
    }
  }
}
