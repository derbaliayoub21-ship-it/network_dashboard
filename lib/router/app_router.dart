import 'package:go_router/go_router.dart';

import '../auth/auth_provider.dart';
import '../auth/login_page.dart';
import '../auth/pin_page.dart';
import '../home/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final location = state.matchedLocation;
      final auth = authController.state;

      if (location == '/login') {
        return auth.isLoggedIn ? '/pin' : null;
      }

      if (location == '/pin') {
        if (!auth.isLoggedIn) return '/login';
        return auth.isPinVerified ? '/home' : null;
      }

      if (location == '/home') {
        return (auth.isLoggedIn && auth.isPinVerified) ? null : '/login';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/pin', builder: (context, state) => const PinPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
}
