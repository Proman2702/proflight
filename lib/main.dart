import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/service/auth/auth_service.dart';
import 'package:proflight/ui/auth_gate.dart';
import 'package:proflight/ui/auth_screen/register/screen.dart';
import 'package:proflight/ui/global_auth_view_model.dart';
import 'package:proflight/ui/auth_screen/screen.dart';
import 'package:proflight/ui/auth_screen/view_model.dart';
import 'package:proflight/ui/main_screen/screen.dart';
import 'package:proflight/ui/main_screen/view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GlobalAuthViewModel())],
      child: MyApp(),
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
