import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflight/di/di_container.dart';
import 'package:proflight/etc/colors.dart';
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
              primary: CustomColors.accent1,
              secondary: CustomColors.accent2,
              surface: CustomColors.surface,
              error: CustomColors.danger,
            ),
            scaffoldBackgroundColor: CustomColors.mainDark,
            textTheme: GoogleFonts.juraTextTheme(Theme.of(context).textTheme),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: CustomColors.surfaceHigh,
              labelStyle: const TextStyle(color: CustomColors.mainText),
              hintStyle: const TextStyle(color: CustomColors.mainText),
              prefixIconColor: CustomColors.accent1,
              suffixIconColor: CustomColors.mainText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: CustomColors.accent1,
                  width: 1.4,
                ),
              ),
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: CustomColors.accent1,
              selectionColor: Color(0x554F9EAC),
              selectionHandleColor: CustomColors.accent1,
            ),
          ),
        ),
      ),
    );
  }
}
