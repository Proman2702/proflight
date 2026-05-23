import 'dart:async';
import 'dart:convert';

import 'package:proflight/models/auth_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class TokenStorage {
  AuthSession? get currentSession;

  Stream<AuthSession?> watchSession();

  Future<void> saveSession(AuthSession session);

  Future<void> clearSession();
}

class SharedPreferencesTokenStorage implements TokenStorage {
  SharedPreferencesTokenStorage._(this._prefs) {
    final raw = _prefs.getString(_sessionKey);
    if (raw != null) {
      _session = AuthSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
  }

  static const _sessionKey = 'proflight.auth_session';

  final SharedPreferences _prefs;
  final _controller = StreamController<AuthSession?>.broadcast();
  AuthSession? _session;

  static Future<SharedPreferencesTokenStorage> create() async {
    return SharedPreferencesTokenStorage._(
      await SharedPreferences.getInstance(),
    );
  }

  @override
  AuthSession? get currentSession => _session;

  @override
  Stream<AuthSession?> watchSession() => _controller.stream;

  @override
  Future<void> saveSession(AuthSession session) async {
    _session = session;
    await _prefs.setString(_sessionKey, jsonEncode(session.toJson()));
    _controller.add(_session);
  }

  @override
  Future<void> clearSession() async {
    _session = null;
    await _prefs.remove(_sessionKey);
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
