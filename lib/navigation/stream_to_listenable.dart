import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:proflight/models/auth_user.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';

class SessionListenable extends ChangeNotifier {
  SessionListenable(this._authRepository) {
    _sub = _authRepository.authStateChanges().listen((_) => notifyListeners());
  }

  final AuthRepository _authRepository;
  StreamSubscription<AuthUser?>? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
