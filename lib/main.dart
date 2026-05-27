import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/di/di_container.dart';
import 'package:proflight/navigation/routes.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final container = await DiContainer.create();

  runApp(App(container: container));
}

class App extends StatelessWidget {
  const App({required this.container, super.key});

  final DiContainer container;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DiContainer>(
          create: (_) => container,
          dispose: (_, container) => container.dispose(),
        ),
        Provider<AuthRepository>.value(value: container.authRepository),
        Provider<AppDatabaseRepository>.value(
          value: container.databaseRepository,
        ),
        Provider<AppRouter>(
          create: (context) => AppRouter(context.read<AuthRepository>()),
          dispose: (_, router) => router.dispose(),
        ),
      ],
      child: Builder(
        builder: (context) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: context.read<AppRouter>().router,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4C9AC4),
              secondary: Color(0xFFC38091),
              surface: Color(0xFF181818),
              error: Color(0xFFE53B3B),
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            textTheme: GoogleFonts.juraTextTheme(Theme.of(context).textTheme),
          ),
        ),
      ),
    );
  }
}
