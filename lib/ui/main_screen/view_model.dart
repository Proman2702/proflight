import 'package:flutter/material.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';

class MainScreenModel extends ChangeNotifier {
  MainScreenModel(this._authService);

  final AuthRepository _authService;

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}
