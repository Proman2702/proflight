import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthGateViewModel extends ChangeNotifier {
  AuthGateViewModel(this._authService) {
    final currentUser = _authService.getUser;
    if (currentUser != null) {
      _userState = AuthStatus.authenticated;
    } else {
      _userState = AuthStatus.unauthenticated;
    }
    notifyListeners();
    _subscription = _authService.authStateChanges().listen(_onUserChanged);
  }

  final AuthService _authService;
  StreamSubscription<User?>? _subscription;

  AuthStatus _userState = AuthStatus.unknown;

  AuthStatus get userState => _userState;

  void _onUserChanged(User? user) {
    _userState = user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
