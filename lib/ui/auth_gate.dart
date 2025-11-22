import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';
import 'package:proflight/ui/auth_screen/view_model.dart';
import 'package:proflight/ui/global_auth_view_model.dart';
import 'package:proflight/ui/auth_screen/screen.dart';
import 'package:proflight/ui/main_screen/screen.dart';
import 'package:proflight/ui/main_screen/view_model.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<GlobalAuthViewModel>();
    if (status.userState == AuthStatus.authenticated) {
      return ChangeNotifierProvider(create: (_) => MainScreenModel(), child: MainScreen());
    } else if (status.userState == AuthStatus.unauthenticated) {
      return ChangeNotifierProvider(create: (_) => AuthScreenModel(), child: AuthScreen());
    }

    return Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));
  }
}
