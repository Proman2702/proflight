import 'package:flutter/material.dart';

class AuthScreenModel extends ChangeNotifier {
  void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }
}
