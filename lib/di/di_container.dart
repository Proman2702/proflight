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

class DiContainer {
  const DiContainer._({
    required this.authRepository,
    required this.databaseRepository,
    void Function()? dispose,
  }) : _dispose = dispose;

  final AuthRepository authRepository;
  final AppDatabaseRepository databaseRepository;
  final void Function()? _dispose;

  static Future<DiContainer> create() async {
    const backend = String.fromEnvironment(
      'PROFLIGHT_BACKEND',
      defaultValue: 'firebase',
    );

    if (backend == 'firebase') {
      final firestore = FirebaseFirestore.instance;
      final authRepository = FirebaseAuthRepository(
        FirebaseAuth.instance,
        firestore,
      );
      return DiContainer._(
        authRepository: authRepository,
        databaseRepository: FirebaseAppDatabaseRepository(
          firestore,
          authRepository,
        ),
      );
    }

    final tokenStorage = await SharedPreferencesTokenStorage.create();
    const baseUrl = String.fromEnvironment(
      'PROFLIGHT_API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );
    final apiClient = SpringApiClient(
      baseUrl: baseUrl,
      tokenStorage: tokenStorage,
    );

    return DiContainer._(
      authRepository: SpringAuthRepository(apiClient, tokenStorage),
      databaseRepository: SpringAppDatabaseRepository(apiClient),
      dispose: tokenStorage.dispose,
    );
  }

  void dispose() => _dispose?.call();
}
