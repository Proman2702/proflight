import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proflight/core/error/failures.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/auth_user.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/repositories/server/network_guard.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

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
      await _createInitialProfile(
        uid: user.uid,
        email: email,
        profileName: profileName,
        fio: fio,
        company: company,
      );
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

extension on FirebaseAuthRepository {
  Future<void> _createInitialProfile({
    required String uid,
    required String email,
    String? profileName,
    String? fio,
    String? company,
  }) async {
    final resolvedProfileName = _resolveProfileName(email, profileName);
    final resolvedFio = fio?.trim().isNotEmpty == true
        ? fio!.trim()
        : email.trim();
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('profiles')
        .doc(resolvedProfileName)
        .set({
          'profileName': resolvedProfileName,
          'fio': resolvedFio,
          if (company != null && company.trim().isNotEmpty)
            'company': company.trim(),
          'flytimeAll': '00:00:00',
          'flytimeDay': '00:00:00',
          'flytimeNight': '00:00:00',
          'addAll': 0,
          'addDay': 0,
          'addNight': 0,
        });
  }

  String _resolveProfileName(String email, String? profileName) {
    final candidate = profileName?.trim();
    if (candidate != null && candidate.isNotEmpty) return candidate;
    return '${email.trim().split('@').first}-profile';
  }
}

extension FirebaseUserMapper on User {
  AuthUser toAuthUser() =>
      AuthUser(id: uid, email: email, isEmailVerified: emailVerified);
}
