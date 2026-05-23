import 'package:dio/dio.dart';
import 'package:proflight/models/auth_session.dart';
import 'package:proflight/repositories/storage/token_storage.dart';

class SpringApiClient {
  SpringApiClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
    Dio? dio,
  }) : _tokenStorage = tokenStorage,
       dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 20),
               contentType: Headers.jsonContentType,
             ),
           ) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.extra['skipAuth'] == true) {
            handler.next(options);
            return;
          }

          final session = _tokenStorage.currentSession;
          if (session != null) {
            options.headers['Authorization'] =
                '${session.tokenType} ${session.accessToken}';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final request = error.requestOptions;
          final canRefresh =
              error.response?.statusCode == 401 &&
              request.extra['skipAuth'] != true &&
              request.extra['retriedAfterRefresh'] != true;

          if (!canRefresh || !await _refreshTokens()) {
            handler.next(error);
            return;
          }

          final session = _tokenStorage.currentSession;
          final retryOptions = Options(
            method: request.method,
            headers: {
              ...request.headers,
              if (session != null)
                'Authorization': '${session.tokenType} ${session.accessToken}',
            },
            responseType: request.responseType,
            contentType: request.contentType,
            extra: {...request.extra, 'retriedAfterRefresh': true},
          );

          try {
            final response = await this.dio.request<Object?>(
              request.path,
              data: request.data,
              queryParameters: request.queryParameters,
              options: retryOptions,
            );
            handler.resolve(response);
          } on DioException catch (e) {
            handler.next(e);
          }
        },
      ),
    );
  }

  final Dio dio;
  final TokenStorage _tokenStorage;

  Future<bool> _refreshTokens() async {
    final session = _tokenStorage.currentSession;
    if (session == null) return false;

    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/api/auth/refresh',
        data: {'refreshToken': session.refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data;
      if (data == null) return false;

      await _tokenStorage.saveSession(
        AuthSession.fromJson(data, email: session.email),
      );
      return true;
    } on DioException {
      await _tokenStorage.clearSession();
      return false;
    }
  }
}
