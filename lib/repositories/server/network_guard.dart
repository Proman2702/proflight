import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:proflight/core/error/failures.dart';
import 'package:proflight/core/error/result.dart';

class RepositoryGuard {
  static Future<Result<T>> firebaseAuth<T>(
    Future<Result<T>> Function() action,
  ) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      return Err(_mapFirebaseAuthError(e));
    } catch (e) {
      return Err(AuthFailure(AuthFailureType.unknown, message: e.toString()));
    }
  }

  static Future<Result<T>> firebaseDatabase<T>(
    Future<Result<T>> Function() action,
  ) async {
    try {
      return await action();
    } on FirebaseException catch (e) {
      return Err(_mapFirebaseDatabaseError(e));
    } catch (e) {
      return Err(
        DatabaseFailure(DatabaseFailureType.unknown, message: e.toString()),
      );
    }
  }

  static Future<Result<T>> spring<T>(
    Future<Result<T>> Function() action,
  ) async {
    try {
      return await action();
    } on DioException catch (e) {
      return Err(_mapDioError(e));
    } catch (e) {
      return Err(
        NetworkFailure(NetworkFailureType.unknown, message: e.toString()),
      );
    }
  }

  static AuthFailure _mapFirebaseAuthError(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => AuthFailure(
        AuthFailureType.invalidInput,
        message: e.message,
      ),
      'email-already-in-use' => AuthFailure(
        AuthFailureType.exists,
        message: e.message,
      ),
      'weak-password' => AuthFailure(
        AuthFailureType.weakPassword,
        message: e.message,
      ),
      'user-not-found' => AuthFailure(
        AuthFailureType.notFound,
        message: e.message,
      ),
      'wrong-password' || 'invalid-credential' => AuthFailure(
        AuthFailureType.wrongCredentials,
        message: e.message,
      ),
      'requires-recent-login' => AuthFailure(
        AuthFailureType.unauthorized,
        message: e.message,
      ),
      _ => AuthFailure(AuthFailureType.unknown, message: e.message),
    };
  }

  static DatabaseFailure _mapFirebaseDatabaseError(FirebaseException e) {
    return switch (e.code) {
      'permission-denied' => DatabaseFailure(
        DatabaseFailureType.permissionDenied,
        message: e.message,
      ),
      'unauthenticated' => DatabaseFailure(
        DatabaseFailureType.unauthenticated,
        message: e.message,
      ),
      'not-found' => DatabaseFailure(
        DatabaseFailureType.notFound,
        message: e.message,
      ),
      'unavailable' => DatabaseFailure(
        DatabaseFailureType.unavailable,
        message: e.message,
      ),
      'invalid-argument' => DatabaseFailure(
        DatabaseFailureType.invalidArgument,
        message: e.message,
      ),
      _ => DatabaseFailure(DatabaseFailureType.unknown, message: e.message),
    };
  }

  static NetworkFailure _mapDioError(DioException e) {
    final code = e.response?.statusCode;
    final data = e.response?.data;
    final message = _extractMessage(data) ?? e.message ?? e.toString();

    return switch (code) {
      400 => NetworkFailure(NetworkFailureType.badRequest, message: message),
      401 => NetworkFailure(NetworkFailureType.unauthorized, message: message),
      403 => NetworkFailure(NetworkFailureType.forbidden, message: message),
      404 => NetworkFailure(NetworkFailureType.notFound, message: message),
      409 => NetworkFailure(NetworkFailureType.conflict, message: message),
      null => NetworkFailure(NetworkFailureType.unavailable, message: message),
      _ => NetworkFailure(
        NetworkFailureType.unknown,
        message: 'HTTP $code: $message',
      ),
    };
  }

  static String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final details = data['details'];
      if (details is List && details.isNotEmpty) return details.join('\n');
      return data['message'] as String?;
    }
    return data?.toString();
  }
}
