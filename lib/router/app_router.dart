import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';

// Define the router provider – used in main.dart
final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  final userRole = ref.watch(userRoleProvider).value;

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final goingToLogin = state.matchedLocation == '/login';
      final goingToForgotPassword = state.matchedLocation == '/forgot-password';

      // 1. Allow unauthenticated access to login and forgot-password
      if (!isLoggedIn && (goingToLogin || goingToForgotPassword)) {
        return null; // allow navigation
      }

      // 2. If not logged in and trying to access any other route → redirect to login
      if (!isLoggedIn && !goingToLogin && !goingToForgotPassword) {
        return '/login';
      }

      // 3. If logged in and trying to go to login or forgot-password → redirect to home
      if (isLoggedIn && (goingToLogin || goingToForgotPassword)) {
        return '/home';
      }

      // 4. (Optional) Role‑based guards can be added here using `userRole`
      // Example:
      // if (state.matchedLocation == '/admin' && userRole != 'admin') {
      //   return '/home';
      // }

      // Allow all other navigation
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const AppShell(),
      ),
      // Add other routes here (profile, opportunities, etc.)
    ],
  );
});