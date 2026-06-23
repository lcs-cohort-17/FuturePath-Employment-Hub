import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/profile/notifications_screen.dart';
import '../screens/profile/track_applications_screen.dart';
import '../screens/jobs/employer_detail_screen.dart';
import '../models/employer.dart';

class AppRouter {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String trackApplications = '/track-applications';
  static const String employerDetail = '/employer-detail';

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
        final args = settings.arguments;
        final List<Map<String, dynamic>> notificationsList = 
            (args is List<Map<String, dynamic>>) ? args : [];
            
        return MaterialPageRoute(
          builder: (_) => NotificationsScreen(notifications: notificationsList),
          settings: settings,
        );
      case trackApplications:
        final args = settings.arguments;
        final List<Map<String, dynamic>> appsList = 
            (args is List<Map<String, dynamic>>) ? args : [];
            
        return MaterialPageRoute(
          builder: (_) => TrackApplicationsScreen(applications: appsList),
          settings: settings,
        );
      case employerDetail:
        final args = settings.arguments;
        final EmployerModel? employer = (args is EmployerModel) ? args : null;
        
        return MaterialPageRoute(
          builder: (_) => EmployerDetailScreen(employerData: employer),
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
