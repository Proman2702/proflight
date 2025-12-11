import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class RecoveryScreenModel extends ChangeNotifier {
  final emailController = TextEditingController();
  String? _errorMessage;

  final AuthService _authService;

  RecoveryScreenModel(this._authService);

  String? get errorMessage => _errorMessage;

  Future<bool> sendVerification() async {
    _errorMessage = null;

    try {
      await _authService.sendPasswordReset(emailController.text);

      return true; // успех
    } catch (e) {
      _errorMessage = e.toString(); // тут можно мапить в красивый текст
      notifyListeners();
      return false;
    }
  }
}
