import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/jobs/opportunity_list_screen.dart';
import '../screens/jobs/opportunity_detail_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart'; // create this screen
import 'admin_guard.dart';

class AppRouter {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String jobs = '/jobs';
  static const String jobDetail = '/job-detail';
  static const String adminDashboard = '/admin'; // new

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


      case adminDashboard:
        return MaterialPageRoute(
          builder: (context) {
            final auth = Provider.of<AuthProvider>(context, listen: false);
            final allowed = checkAdminAccess(context, auth);
            if (!allowed) {
              // Render a blank screen while redirect happens
              return const Scaffold(
                body: SizedBox.shrink(),
              );
            }
            return const AdminDashboardScreen();
          },
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