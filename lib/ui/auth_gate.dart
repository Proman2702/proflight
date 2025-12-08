import 'package:flutter/material.dart';
import 'package:proflight/ui/auth_gate_view_model.dart';
import 'package:proflight/ui/auth_screen/screen.dart';
import 'package:proflight/ui/main_screen/screen.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthGateViewModel>();
    final size = MediaQuery.of(context).size;
    final dpr = MediaQuery.of(context).devicePixelRatio;

    debugPrint('size: ${size.width} x ${size.height}');
    debugPrint('devicePixelRatio: $dpr');

    if (status.userState == AuthStatus.authenticated) {
      return const MainScreen();
    } else if (status.userState == AuthStatus.unauthenticated) {
      return const AuthScreen();
    }

    return const Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()));
  }
}
