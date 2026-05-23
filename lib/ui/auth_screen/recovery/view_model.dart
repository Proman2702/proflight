import 'package:flutter/material.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';

class RecoveryScreenModel extends ChangeNotifier {
  RecoveryScreenModel(this._authService);

  final AuthRepository _authService;

  final emailController = TextEditingController();
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> sendVerification() async {
    _errorMessage = null;

    final result = await _authService.resetPassword(
      email: emailController.text,
    );

    if (result is Err<Unit>) {
      _errorMessage = result.error.message ?? result.error.messageKey;
      notifyListeners();
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
