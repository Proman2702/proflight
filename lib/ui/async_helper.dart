import 'package:flutter/material.dart';

Future<T> withLoadingDialog<T>({required BuildContext context, required Future<T> Function() action}) async {
  // Сохраняем навигатор до await — потом не трогаем контекст напрямую
  final navigator = Navigator.of(context);

  // Показываем диалог с крутилкой
  showDialog(context: context, barrierDismissible: false, builder: (_) => const _LoadingDialog());

  try {
    // Выполняем переданную асинхронную операцию
    return await action();
  } finally {
    // Закрываем диалог в любом случае (успех/ошибка/throw)
    if (navigator.canPop()) {
      navigator.pop();
    }
  }
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [CircularProgressIndicator(), SizedBox(width: 16), Text('Загрузка...')],
        ),
      ),
    );
  }
}
