import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/repositories/auth/firebase/firebase_auth_repository.dart';
import 'package:proflight/repositories/auth/spring/spring_auth_repository.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:proflight/repositories/database/firebase/firebase_app_database_repository.dart';
import 'package:proflight/repositories/database/spring/spring_app_database_repository.dart';
import 'package:proflight/repositories/server/spring_api_client.dart';
import 'package:proflight/repositories/storage/token_storage.dart';

enum BackendKind {
  spring,
  firebase;

  static BackendKind fromEnvironment() {
    const value = String.fromEnvironment(
      'PROFLIGHT_BACKEND',
      defaultValue: 'spring',
    );
    return value == 'firebase' ? BackendKind.firebase : BackendKind.spring;
  }
}

class DiContainer {
  DiContainer._({
    required this.backendKind,
    required this.authRepository,
    required this.databaseRepository,
    this.tokenStorage,
  });

  final BackendKind backendKind;
  final AuthRepository authRepository;
  final AppDatabaseRepository databaseRepository;
  final TokenStorage? tokenStorage;

  static Future<DiContainer> create({
    BackendKind? backendKind,
    String? springBaseUrl,
  }) async {
    final resolvedBackend = backendKind ?? BackendKind.fromEnvironment();

    if (resolvedBackend == BackendKind.firebase) {
      final authRepository = FirebaseAuthRepository(FirebaseAuth.instance);
      return DiContainer._(
        backendKind: resolvedBackend,
        authRepository: authRepository,
        databaseRepository: FirebaseAppDatabaseRepository(
          FirebaseFirestore.instance,
          authRepository,
        ),
      );
    }

    final tokenStorage = await SharedPreferencesTokenStorage.create();
    const envBaseUrl = String.fromEnvironment(
      'PROFLIGHT_API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
    final apiClient = SpringApiClient(
      baseUrl: springBaseUrl ?? envBaseUrl,
      tokenStorage: tokenStorage,
    );

    return DiContainer._(
      backendKind: resolvedBackend,
      authRepository: SpringAuthRepository(apiClient, tokenStorage),
      databaseRepository: SpringAppDatabaseRepository(apiClient),
      tokenStorage: tokenStorage,
    );
  }

  void dispose() {
    final storage = tokenStorage;
    if (storage is SharedPreferencesTokenStorage) storage.dispose();
  }
}
