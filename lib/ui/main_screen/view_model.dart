import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class MainScreenModel extends ChangeNotifier {
  final AuthService authService = AuthService();

  void signOut() async {
    await authService.signOut();
    notifyListeners();
  }
}
