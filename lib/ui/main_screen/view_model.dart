import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class MainScreenModel extends ChangeNotifier {
  MainScreenModel(this._authService);

  final AuthService _authService;

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}
