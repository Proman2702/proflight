import 'failure.dart';

extension FailurePresentation on Failure {
  String get userMessage {
    final mapped = switch (messageKey) {
      'auth_invalid_input' => 'Проверьте введенные данные',
      'auth_exists' => 'Аккаунт с такими данными уже существует',
      'auth_weak_password' => 'Пароль слишком простой',
      'auth_not_found' => 'Аккаунт не найден',
      'auth_wrong_credentials' => 'Неверная почта или пароль',
      'auth_unauthorized' => 'Нужно войти в аккаунт',
      'db_permission_denied' => 'Недостаточно прав для операции',
      'db_unauthenticated' => 'Нужно войти в аккаунт',
      'db_not_found' => 'Данные не найдены',
      'db_conflict' => 'Такая запись уже существует',
      'db_invalid_argument' => 'Некорректные данные',
      'db_unavailable' => 'База данных временно недоступна',
      'network_bad_request' => 'Некорректный запрос',
      'network_unauthorized' => 'Сессия истекла, войдите снова',
      'network_forbidden' => 'Недостаточно прав для операции',
      'network_not_found' => 'Данные не найдены',
      'network_conflict' => 'Такая запись уже существует',
      'network_unavailable' => 'Сервер временно недоступен',
      _ => null,
    };
    if (mapped != null) return mapped;

    final rawMessage = message?.trim();
    if (rawMessage != null && rawMessage.isNotEmpty) return rawMessage;
    return 'Неизвестная ошибка';
  }
}
