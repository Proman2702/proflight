import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/service/auth/auth_service.dart';
import 'package:proflight/ui/auth_gate.dart';
import 'package:proflight/ui/auth_gate_view_model.dart';
import 'package:proflight/ui/auth_screen/recovery/view_model.dart';
import 'package:proflight/ui/auth_screen/register/screen.dart';
import 'package:proflight/ui/auth_screen/register/view_model.dart';
import 'package:proflight/ui/auth_screen/view_model.dart';
import 'package:proflight/ui/main_screen/view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// пококок
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()), // DI
        ChangeNotifierProvider(create: (context) => AuthGateViewModel(context.read<AuthService>())),
        ChangeNotifierProvider(create: (context) => AuthScreenModel(context.read<AuthService>())),
        ChangeNotifierProvider(create: (context) => MainScreenModel(context.read<AuthService>())),
        ChangeNotifierProvider(create: (context) => RegisterScreenModel(context.read<AuthService>())),
        ChangeNotifierProvider(create: (context) => RecoveryScreenModel(context.read<AuthService>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (_) => const AuthGate(), '/register': (_) => const RegisterScreen()},
      theme: ThemeData(textTheme: GoogleFonts.juraTextTheme(Theme.of(context).textTheme)),
    );
  }
}
