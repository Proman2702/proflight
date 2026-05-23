import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:proflight/navigation/stream_to_listenable.dart';
import 'package:proflight/repositories/auth/auth_repository.dart';
import 'package:proflight/ui/auth_screen/recovery/screen.dart';
import 'package:proflight/ui/auth_screen/recovery/view_model.dart';
import 'package:proflight/ui/auth_screen/register/screen.dart';
import 'package:proflight/ui/auth_screen/register/view_model.dart';
import 'package:proflight/ui/auth_screen/screen.dart';
import 'package:proflight/ui/auth_screen/view_model.dart';
import 'package:proflight/ui/main_screen/screen.dart';
import 'package:proflight/ui/main_screen/view_model.dart';

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
        if (loggedIn && inAuthFlow) return '/main';
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
        GoRoute(
          path: '/main',
          builder: (context, state) => ChangeNotifierProvider(
            create: (context) =>
                MainScreenModel(context.read<AuthRepository>()),
            child: const MainScreen(),
          ),
        ),
      ],
    );
  }

  final AuthRepository _authRepository;
  final SessionListenable _refresh;

  late final GoRouter router;

  void dispose() => _refresh.dispose();
}
