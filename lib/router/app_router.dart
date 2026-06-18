import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/profile/notifications_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String notifications = '/notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
      case notifications:
        final args = settings.arguments as List<Map<String, dynamic>>;
        return MaterialPageRoute(
          builder: (_) => NotificationsScreen(notifications: args),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }
}