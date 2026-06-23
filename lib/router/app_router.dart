import 'package:flutter/material.dart';

import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(
            onNavigateHome: () {
              Navigator.pushReplacementNamed(
                context,
                home,
              );
            },
            onNavigateLogin: () {
              Navigator.pushReplacementNamed(
                context,
                login,
              );
            },
          ),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const AppShell(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(
            onNavigateHome: () {
              Navigator.pushReplacementNamed(
                context,
                home,
              );
            },
            onNavigateLogin: () {
              Navigator.pushReplacementNamed(
                context,
                login,
              );
            },
          ),
          settings: settings,
        );
    }
  }
}