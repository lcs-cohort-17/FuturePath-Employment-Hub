import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/admin/admin_employers_screen.dart';
import '../screens/admin/admin_job_applications_screen.dart';
import '../screens/admin/admin_applicants_screen.dart';
import '../screens/admin/admin_enrolments_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String adminJobApplications = '/admin/job-applications';
  static const String adminEmployers = '/admin/employers';
  static const String adminApplicants = '/admin/applicants';
  static const String adminEnrolments = '/admin/enrolments';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
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
        ); //marco added the work below
      case adminEmployers:
        return MaterialPageRoute(
          builder: (_) => const AdminEmployersScreen(),
          settings: settings,
        );
// Sisonke sprint 2 Ticket UIUX-019
      case adminApplicants:
        return MaterialPageRoute(
          builder: (_) => const AdminApplicantsScreen(),
          settings: settings,
        );
// Qaasim sprint 2 UIUX ticket 022
      case '/admin/job-applications':
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => AdminJobApplicationsScreen(
            jobId: args['jobId']!,
            jobTitle: args['jobTitle']!,
          ),
          settings: settings,
        );
//Qaasim  ticket ends here.

//Onke/021 — Admin Enrolment Management
      case adminEnrolments:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => AdminEnrolmentsScreen(
            programmeId: args['programmeId']!,
            programmeName: args['programmeName'] ?? 'Programme',
          ),
          settings: settings,
        );
//Onke/021 ends here
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
    }
  }
}
