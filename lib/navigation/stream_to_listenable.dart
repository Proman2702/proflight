import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:proflight/models/auth_user.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';

class SessionListenable extends ChangeNotifier {
  SessionListenable(this._authRepository) {
    _sub = _authRepository.authStateChanges().listen((_) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
    });
  }

  final AuthRepository _authRepository;
  StreamSubscription<AuthUser?>? _sub;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _sub?.cancel();
    super.dispose();
  }
}
