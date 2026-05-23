import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proflight/models/auth_user.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthGateViewModel extends ChangeNotifier {
  AuthGateViewModel(this._authService) {
    _userState = _authService.currentUser == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
    _subscription = _authService.authStateChanges().listen(_onUserChanged);
  }

  final AuthRepository _authService;
  StreamSubscription<AuthUser?>? _subscription;

  AuthStatus _userState = AuthStatus.unknown;

  AuthStatus get userState => _userState;

  void _onUserChanged(AuthUser? user) {
    _userState = user == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
