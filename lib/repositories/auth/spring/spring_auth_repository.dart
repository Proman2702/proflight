import 'package:dio/dio.dart';
import 'package:proflight/core/error/result.dart';
import 'package:proflight/models/auth_session.dart';
import 'package:proflight/models/auth_user.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/repositories/server/network_guard.dart';
import 'package:proflight/repositories/server/spring_api_client.dart';
import 'package:proflight/repositories/storage/token_storage.dart';

class SpringAuthRepository implements AuthRepository {
  SpringAuthRepository(this._apiClient, this._tokenStorage);

  final SpringApiClient _apiClient;
  final TokenStorage _tokenStorage;

  @override
  AuthUser? get currentUser {
    final session = _tokenStorage.currentSession;
    final email = session?.email;
    if (session == null || email == null) return null;
    return AuthUser(id: email, email: email);
  }

  @override
  Stream<AuthUser?> authStateChanges() {
    return _tokenStorage.watchSession().map((session) {
      final email = session?.email;
      if (session == null || email == null) return null;
      return AuthUser(id: email, email: email);
    });
  }

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) {
    return RepositoryGuard.spring(() async {
      final normalizedEmail = email.trim();
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {'email': normalizedEmail, 'password': password},
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data;
      if (data == null) throw StateError('Empty login response');

      await _tokenStorage.saveSession(
        AuthSession.fromJson(data, email: normalizedEmail),
      );
      return AuthUser(id: normalizedEmail, email: normalizedEmail);
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
    return RepositoryGuard.spring(() async {
      final normalizedEmail = email.trim();
      final resolvedProfileName = _resolveProfileName(
        normalizedEmail,
        profileName,
      );
      final resolvedFio = fio?.trim();
      if (resolvedFio == null || resolvedFio.isEmpty) {
        throw DioException(
          requestOptions: RequestOptions(path: '/api/auth/register'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/auth/register'),
            statusCode: 400,
            data: {'message': 'fio is required'},
          ),
        );
      }

      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/api/auth/register',
        data: {
          'email': normalizedEmail,
          'password': password,
          'profileName': resolvedProfileName,
          'fio': resolvedFio,
          if (company != null && company.trim().isNotEmpty)
            'company': company.trim(),
        },
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data;
      if (data == null) throw StateError('Empty register response');

      await _tokenStorage.saveSession(
        AuthSession.fromJson(data, email: normalizedEmail),
      );
      return AuthUser(id: normalizedEmail, email: normalizedEmail);
    });
  }

  @override
  Future<Result<Unit>> resetPassword({required String email}) {
    return RepositoryGuard.spring(() async {
      await _apiClient.dio.post<void>(
        '/api/auth/forgot-password',
        data: {'email': email.trim()},
        options: Options(extra: {'skipAuth': true}),
      );
      return const Unit();
    });
  }

  @override
  Future<Result<Unit>> resetPasswordWithToken({
    required String token,
    required String newPassword,
  }) {
    return RepositoryGuard.spring(() async {
      await _apiClient.dio.post<void>(
        '/api/auth/reset-password',
        data: {'token': token, 'newPassword': newPassword},
        options: Options(extra: {'skipAuth': true}),
      );
      return const Unit();
    });
  }

  @override
  Future<Result<Unit>> signOut() {
    return RepositoryGuard.spring(() async {
      final refreshToken = _tokenStorage.currentSession?.refreshToken;
      if (refreshToken != null) {
        await _apiClient.dio.post<void>(
          '/api/auth/logout',
          data: {'refreshToken': refreshToken},
          options: Options(extra: {'skipAuth': true}),
        );
      }
      await _tokenStorage.clearSession();
      return const Unit();
    });
  }

  String _resolveProfileName(String email, String? profileName) {
    final candidate = profileName?.trim();
    if (candidate != null && candidate.isNotEmpty) return candidate;
    final localPart = email.split('@').first;
    return '$localPart-profile';
  }
}
