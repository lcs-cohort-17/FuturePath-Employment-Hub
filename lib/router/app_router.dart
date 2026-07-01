import 'package:flutter/material.dart';

import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/shell/main_shell.dart';
import '../services/auth_services.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case signup:
        return MaterialPageRoute<void>(
          builder: (_) => const SignupScreen(),
          settings: settings,
        );

      case forgotPassword:
        return MaterialPageRoute<void>(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );

      case resetPassword:
        return MaterialPageRoute<void>(
          builder: (_) => const ResetPasswordScreen(),
          settings: settings,
        );

      case home:
        if (!AuthService().isLoggedIn) {
          return MaterialPageRoute<void>(
            builder: (_) => const LoginScreen(),
            settings: const RouteSettings(name: login),
          );
        }

        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(),
          settings: settings,
        );

      default:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: const RouteSettings(name: login),
        );
    }
  }
}