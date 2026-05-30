import 'package:flutter/material.dart';
import 'package:proflight/core/error/error_presentation.dart';
import 'package:proflight/core/error/failure.dart';

void showAppToast(BuildContext context, Failure failure) {
  showAppMessage(context, failure.userMessage);
}

void showAppMessage(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xFF1D1B20),
            fontWeight: FontWeight.w700,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFFFFBFE),
        elevation: 8,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE7E0EC)),
        ),
      ),
    );
}
