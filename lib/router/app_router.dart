import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/jobs/opportunity_list_screen.dart';
import '../screens/jobs/opportunity_detail_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String jobs = '/jobs';
  static const String jobDetail = '/job-detail';

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
      case jobs:
        return MaterialPageRoute(
          builder: (_) => const OpportunityListScreen(),
          settings: settings,
        );
      case jobDetail:
        final opportunity = settings.arguments as Opportunity;
        return MaterialPageRoute(
          builder: (_) => OpportunityDetailScreen(opportunity: opportunity),
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