import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/auth_user.dart';

abstract interface class AuthRepository {
  AuthUser? get currentUser;

  Stream<AuthUser?> authStateChanges();

  Future<Result<AuthUser>> signUp({
    required String email,
    required String password,
    String? profileName,
    String? fio,
    String? company,
  });

  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  });

  Future<Result<Unit>> signOut();

  Future<Result<Unit>> resetPassword({required String email});

  Future<Result<Unit>> resetPasswordWithToken({
    required String token,
    required String newPassword,
  });
}
