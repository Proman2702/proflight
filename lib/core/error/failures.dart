import 'failure.dart';

final class AuthFailure extends Failure {
  AuthFailure(this.type, {this.message});

  final AuthFailureType type;

  @override
  final String? message;

  @override
  String get messageKey => switch (type) {
    AuthFailureType.invalidInput => 'auth_invalid_input',
    AuthFailureType.exists => 'auth_exists',
    AuthFailureType.weakPassword => 'auth_weak_password',
    AuthFailureType.notFound => 'auth_not_found',
    AuthFailureType.wrongCredentials => 'auth_wrong_credentials',
    AuthFailureType.unauthorized => 'auth_unauthorized',
    AuthFailureType.unknown => 'auth_unknown',
  };
}

enum AuthFailureType {
  invalidInput,
  exists,
  weakPassword,
  notFound,
  wrongCredentials,
  unauthorized,
  unknown,
}

final class DatabaseFailure extends Failure {
  DatabaseFailure(this.type, {this.message});

  final DatabaseFailureType type;

  @override
  final String? message;

  @override
  String get messageKey => switch (type) {
    DatabaseFailureType.permissionDenied => 'db_permission_denied',
    DatabaseFailureType.unauthenticated => 'db_unauthenticated',
    DatabaseFailureType.notFound => 'db_not_found',
    DatabaseFailureType.conflict => 'db_conflict',
    DatabaseFailureType.invalidArgument => 'db_invalid_argument',
    DatabaseFailureType.unavailable => 'db_unavailable',
    DatabaseFailureType.unknown => 'db_unknown',
  };
}

enum DatabaseFailureType {
  permissionDenied,
  unauthenticated,
  notFound,
  conflict,
  invalidArgument,
  unavailable,
  unknown,
}

final class NetworkFailure extends Failure {
  NetworkFailure(this.type, {this.message});

  final NetworkFailureType type;

  @override
  final String? message;

  @override
  String get messageKey => switch (type) {
    NetworkFailureType.unauthorized => 'network_unauthorized',
    NetworkFailureType.forbidden => 'network_forbidden',
    NetworkFailureType.notFound => 'network_not_found',
    NetworkFailureType.conflict => 'network_conflict',
    NetworkFailureType.badRequest => 'network_bad_request',
    NetworkFailureType.unavailable => 'network_unavailable',
    NetworkFailureType.unknown => 'network_unknown',
  };
}

enum NetworkFailureType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  unavailable,
  unknown,
}
