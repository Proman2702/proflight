import 'package:flutter/material.dart';
import 'package:proflight/core/error/error_presentation.dart';
import 'package:proflight/core/error/failure.dart';
import 'package:proflight/etc/colors.dart';

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
          style: const TextStyle(color: CustomColors.main),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: CustomColors.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
}
