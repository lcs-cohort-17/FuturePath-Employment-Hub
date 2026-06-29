import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/screens/auth/login_screen.dart';
import 'package:futurepath_employment_hub/screens/auth/forgot_password_screen.dart';
import 'package:futurepath_employment_hub/screens/shell/main_shell.dart';
import 'package:futurepath_employment_hub/screens/profile/track_applications_screen.dart';
import 'package:futurepath_employment_hub/screens/profile/notifications_screen.dart';
import 'package:futurepath_employment_hub/screens/home/search_results_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/employer_detail_screen.dart';
import 'package:futurepath_employment_hub/models/employer.dart';

import 'package:futurepath_employment_hub/screens/profile/cv_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String trackApplications = '/track_application';
  static const String notifications = '/notifications';
  static const String searchResults = '/search_results';
  static const String employerDetail = '/employer_detail';
  static const String cv = '/cv';

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
      case trackApplications:
        return MaterialPageRoute(
          builder: (_) => const TrackApplicationsScreen(
            applications: [
              {
                'title': 'Junior Flutter Developer',
                'company': 'TechNova Solutions',
                'status': 'Under Review',
                'progress': 65,
              },
              {
                'title': 'Digital Marketing Assistant',
                'company': 'GrowthLab Academy',
                'status': 'Accepted',
                'progress': 100,
              },
              {
                'title': 'Salesforce Administration',
                'company': 'FutureTech Africa',
                'status': 'Pending',
                'progress': 10,
              },
            ],
          ),
          settings: settings,
        );
      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      case cv:
        return MaterialPageRoute(
          builder: (_) => const CVScreen(),
          settings: settings,
        );
      case searchResults:
        return MaterialPageRoute(
          builder: (_) => const SearchResultsScreen(),
          settings: settings,
        );
      case employerDetail:
        final employer = settings.arguments as EmployerModel?;
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
