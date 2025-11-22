import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class GlobalAuthViewModel extends ChangeNotifier {
  AuthStatus _userState = AuthStatus.unknown;

  final AuthService authService = AuthService();

  AuthStatus get userState => _userState;

  GlobalAuthViewModel() {
    checkUser();
  }

  void checkUser() {
    authService.authStateChanges().listen((user) {
      if (user == null) {
        _userState = AuthStatus.unauthenticated;
      } else {
        _userState = AuthStatus.authenticated;
      }
    });
    notifyListeners();
  }
}
