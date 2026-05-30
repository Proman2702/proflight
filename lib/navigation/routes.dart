import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
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
          pageBuilder: (context, state) => _noTransitionPage(
            ChangeNotifierProvider(
              create: (context) =>
                  AuthScreenModel(context.read<AuthRepository>()),
              child: const AuthScreen(),
            ),
          ),
          routes: [
            GoRoute(
              path: 'register',
              pageBuilder: (context, state) => _noTransitionPage(
                ChangeNotifierProvider(
                  create: (context) =>
                      RegisterScreenModel(context.read<AuthRepository>()),
                  child: const RegisterScreen(),
                ),
              ),
            ),
            GoRoute(
              path: 'recovery',
              pageBuilder: (context, state) => _noTransitionPage(
                ChangeNotifierProvider(
                  create: (context) =>
                      RecoveryScreenModel(context.read<AuthRepository>()),
                  child: const RecoveryScreen(),
                ),
              ),
            ),
          ],
        ),
        ShellRoute(
          pageBuilder: (context, state, child) => _noTransitionPage(
            MainShell(currentPath: state.uri.path, child: child),
          ),
          routes: [
            GoRoute(
              path: '/main/home',
              pageBuilder: (context, state) => _noTransitionPage(
                ChangeNotifierProvider(
                  create: (context) => _deferredLoad(
                    HomeViewModel(context.read<AppDatabaseRepository>()),
                    (model) => model.load(),
                  ),
                  child: const HomeScreen(),
                ),
              ),
            ),
            GoRoute(
              path: '/main/flights',
              pageBuilder: (context, state) => _noTransitionPage(
                ChangeNotifierProvider(
                  create: (context) => _deferredLoad(
                    FlightsViewModel(context.read<AppDatabaseRepository>()),
                    (model) => model.load(),
                  ),
                  child: const FlightsScreen(),
                ),
              ),
            ),
            GoRoute(
              path: '/main/flights/new',
              pageBuilder: (context, state) => _noTransitionPage(
                ChangeNotifierProvider(
                  create: (context) => _deferredLoad(
                    FlightEditViewModel(
                      context.read<AppDatabaseRepository>(),
                      null,
                    ),
                    (model) => model.load(),
                  ),
                  child: const FlightEditScreen(),
                ),
              ),
            ),
            GoRoute(
              path: '/main/flights/:id',
              pageBuilder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                return _noTransitionPage(
                  ChangeNotifierProvider(
                    create: (context) => _deferredLoad(
                      FlightEditViewModel(
                        context.read<AppDatabaseRepository>(),
                        id,
                      ),
                      (model) => model.load(),
                    ),
                    child: const FlightEditScreen(),
                  ),
                );
              },
            ),
            GoRoute(
              path: '/main/export',
              pageBuilder: (context, state) => _noTransitionPage(
                ChangeNotifierProvider(
                  create: (context) => _deferredLoad(
                    ExportViewModel(context.read<AppDatabaseRepository>()),
                    (model) => model.load(),
                  ),
                  child: const ExportScreen(),
                ),
              ),
            ),
            GoRoute(
              path: '/main/profile',
              pageBuilder: (context, state) => _noTransitionPage(
                ChangeNotifierProvider(
                  create: (context) => _deferredLoad(
                    ProfileViewModel(
                      context.read<AuthRepository>(),
                      context.read<AppDatabaseRepository>(),
                    ),
                    (model) => model.load(),
                  ),
                  child: const ProfileScreen(),
                ),
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

T _deferredLoad<T>(T model, Future<void> Function(T model) load) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    load(model);
  });
  return model;
}

NoTransitionPage<void> _noTransitionPage(Widget child) {
  return NoTransitionPage<void>(child: child);
}
