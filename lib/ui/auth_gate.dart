import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proflight/ui/auth_screen/screen.dart';
import 'package:proflight/ui/main_screen/screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
