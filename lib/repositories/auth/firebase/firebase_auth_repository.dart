import 'package:firebase_auth/firebase_auth.dart';
import 'package:proflight/core/error/failures.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/auth_user.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/repositories/server/network_guard.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final FirebaseAuth _auth;

  @override
  AuthUser? get currentUser => _auth.currentUser?.toAuthUser();

  @override
  Stream<AuthUser?> authStateChanges() {
    return _auth.authStateChanges().map((user) => user?.toAuthUser());
  }

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) {
    return RepositoryGuard.firebaseAuth(() async {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        return Err(
          AuthFailure(
            AuthFailureType.unknown,
            message: 'Firebase user is empty',
          ),
        );
      }
      return Ok(user.toAuthUser());
    });
  }

  @override
  Future<Result<AuthUser>> signUp({
    required String email,
    required String password,
    String? profileName,
    String? fio,
    String? company,
  }) {
    return RepositoryGuard.firebaseAuth(() async {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (fio != null && fio.trim().isNotEmpty) {
        await cred.user?.updateDisplayName(fio.trim());
      }
      final user = cred.user;
      if (user == null) {
        return Err(
          AuthFailure(
            AuthFailureType.unknown,
            message: 'Firebase user is empty',
          ),
        );
      }
      return Ok(user.toAuthUser());
    });
  }

  @override
  Future<Result<Unit>> resetPassword({required String email}) {
    return RepositoryGuard.firebaseAuth(() async {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const Ok(Unit());
    });
  }

  @override
  Future<Result<Unit>> resetPasswordWithToken({
    required String token,
    required String newPassword,
  }) {
    return RepositoryGuard.firebaseAuth(() async {
      await _auth.confirmPasswordReset(code: token, newPassword: newPassword);
      return const Ok(Unit());
    });
  }

  @override
  Future<Result<Unit>> signOut() {
    return RepositoryGuard.firebaseAuth(() async {
      await _auth.signOut();
      return const Ok(Unit());
    });
  }
}

extension FirebaseUserMapper on User {
  AuthUser toAuthUser() =>
      AuthUser(id: uid, email: email, isEmailVerified: emailVerified);
}
