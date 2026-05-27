import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:proflight/navigation/stream_to_listenable.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/repositories/database/app_database_repository.dart';
import 'package:proflight/ui/auth_screen/recovery/screen.dart';
import 'package:proflight/ui/auth_screen/recovery/view_model.dart';
import 'package:proflight/ui/auth_screen/register/screen.dart';
import 'package:proflight/ui/auth_screen/register/view_model.dart';
import 'package:proflight/ui/auth_screen/screen.dart';
import 'package:proflight/ui/auth_screen/view_model.dart';
import 'package:proflight/ui/export/screen.dart';
import 'package:proflight/ui/export/view_model.dart';
import 'package:proflight/ui/flight_edit/screen.dart';
import 'package:proflight/ui/flight_edit/view_model.dart';
import 'package:proflight/ui/flights/screen.dart';
import 'package:proflight/ui/flights/view_model.dart';
import 'package:proflight/ui/home/screen.dart';
import 'package:proflight/ui/home/view_model.dart';
import 'package:proflight/ui/main_shell.dart';
import 'package:proflight/ui/profile/screen.dart';
import 'package:proflight/ui/profile/view_model.dart';

class AppRouter {
  AppRouter(this._authRepository)
    : _refresh = SessionListenable(_authRepository) {
    router = GoRouter(
      initialLocation: '/auth',
      refreshListenable: _refresh,
      redirect: (context, state) {
        final loggedIn = _authRepository.currentUser != null;
        final path = state.uri.path;
        final inAuthFlow = path == '/auth' || path.startsWith('/auth/');

        if (!loggedIn && !inAuthFlow) return '/auth';
        if (loggedIn && inAuthFlow) return '/main/home';
        if (loggedIn && path == '/main') return '/main/home';
        return null;
      },
      routes: [
        GoRoute(
          path: '/auth',
          builder: (context, state) => ChangeNotifierProvider(
            create: (context) =>
                AuthScreenModel(context.read<AuthRepository>()),
            child: const AuthScreen(),
          ),
          routes: [
            GoRoute(
              path: 'register',
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) =>
                    RegisterScreenModel(context.read<AuthRepository>()),
                child: const RegisterScreen(),
              ),
            ),
            GoRoute(
              path: 'recovery',
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) =>
                    RecoveryScreenModel(context.read<AuthRepository>()),
                child: const RecoveryScreen(),
              ),
            ),
          ],
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MainShell(currentPath: state.uri.path, child: child);
          },
          routes: [
            GoRoute(
              path: '/main/home',
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) =>
                    HomeViewModel(context.read<AppDatabaseRepository>())
                      ..load(),
                child: const HomeScreen(),
              ),
            ),
            GoRoute(
              path: '/main/flights',
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) =>
                    FlightsViewModel(context.read<AppDatabaseRepository>())
                      ..load(),
                child: const FlightsScreen(),
              ),
            ),
            GoRoute(
              path: '/main/flights/new',
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => FlightEditViewModel(
                  context.read<AppDatabaseRepository>(),
                  null,
                )..load(),
                child: const FlightEditScreen(),
              ),
            ),
            GoRoute(
              path: '/main/flights/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return ChangeNotifierProvider(
                  create: (context) => FlightEditViewModel(
                    context.read<AppDatabaseRepository>(),
                    id,
                  )..load(),
                  child: const FlightEditScreen(),
                );
              },
            ),
            GoRoute(
              path: '/main/export',
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) =>
                    ExportViewModel(context.read<AppDatabaseRepository>())
                      ..load(),
                child: const ExportScreen(),
              ),
            ),
            GoRoute(
              path: '/main/profile',
              builder: (context, state) => ChangeNotifierProvider(
                create: (context) => ProfileViewModel(
                  context.read<AuthRepository>(),
                  context.read<AppDatabaseRepository>(),
                )..load(),
                child: const ProfileScreen(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  final AuthRepository _authRepository;
  final SessionListenable _refresh;

  late final GoRouter router;

  void dispose() => _refresh.dispose();
}
