import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/admin/admin_employers_screen.dart';
import '../screens/admin/admin_job_applications_screen.dart';
import '../screens/admin/admin_applicants_screen.dart';
import '../screens/admin/admin_enrolments_screen.dart';
import '../screens/admin/admin_activity_screen.dart';
import '../screens/auth/admin_login_screen.dart';
import '../screens/auth/staff_registration_screen.dart';
import '../screens/admin/admin_staff_mgmt_screen.dart';
import '../screens/admin/admin_programmes_screen.dart';
import '../screens/admin/admin_profile_screen.dart';
import '../screens/shell/admin_shell.dart';
// Staff imports
import '../screens/staff/staff_shell.dart';
import '../screens/staff/staff_add_job.dart';
import '../screens/staff/staff_edit_job.dart';
import '../screens/staff/staff_add_programme.dart';
import '../screens/staff/staff_edit_programme.dart';
import '../models/staff_job_model.dart';
import '../models/staff_programme_model.dart';

class AppRouter {
  static const String login = '/login';
  static const String adminLogin = '/admin-login';
  static const String adminStaffMgmt = '/admin/staff-management';
  static const String signup = '/signup';
  static const String staffSignup = '/staff-signup';
  static const String staffDashboard = '/staff-dashboard';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  // Staff routes
  static const String staffAddJob = '/staff/jobs/add';
  static const String staffEditJob = '/staff/jobs/edit';
  static const String staffAddProgramme = '/staff/programmes/add';
  static const String staffEditProgramme = '/staff/programmes/edit';
//Abdul is testing this out- eventually
  static const String staffRegister = '/staff-register';

  static const String adminHome = '/admin/home';
  static const String adminJobApplications = '/admin/job-applications';
  static const String adminEmployers = '/admin/employers';
  static const String adminApplicants = '/admin/applicants';
  static const String adminEnrolments = '/admin/enrolments';
  static const String adminActivity = '/admin/activity';
  static const String adminProgrammes = '/admin/programmes';
  static const String adminProfile = '/admin/profile';

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
    case adminLogin:
    return MaterialPageRoute(
    builder: (_) => const AdminLoginScreen(),
    settings: settings,
    );
    case adminStaffMgmt:
    return MaterialPageRoute(
    builder: (_) => const AdminStaffMgmtScreen(),
    settings: settings,);
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
      case adminHome:
        return MaterialPageRoute(
          builder: (_) => const AdminShell(),
          settings: settings,
        );
      case adminEmployers:
        return MaterialPageRoute(
          builder: (_) => const AdminEmployersScreen(),
          settings: settings,
        );
    // case staffRegister:
    //   return MaterialPageRoute(
    //     builder: (_) => const SignUpScreen(), // Or whatever your staff screen widget is named
    //     settings: settings,
    //   );

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

// Antonio ticket 017 — Admin Activity Log
      case adminActivity:
        return MaterialPageRoute(
          builder: (_) => const AdminActivityScreen(),
        );
// Antonio ticket 017 ends here

// UIUX-017 / UIUX-021 — Admin Programmes
      case adminProgrammes:
        return MaterialPageRoute(
          builder: (_) => const AdminProgrammesScreen(),
        );

// UIUX-025 — Admin Profile
      case adminProfile:
        return MaterialPageRoute(
          builder: (_) => const AdminProfileScreen(),
        );
    // Staff routes
      case staffAddJob:
        return MaterialPageRoute(
          builder: (_) => const StaffAddJobScreen(),
          settings: settings,
        );
      case staffEditJob:
        final job = settings.arguments as StaffJobModel;
        return MaterialPageRoute(
          builder: (_) => StaffEditJobScreen(job: job),
          settings: settings,
        );
      case staffAddProgramme:
        return MaterialPageRoute(
          builder: (_) => const StaffAddProgrammeScreen(),
          settings: settings,
        );
      case staffEditProgramme:
        final programme = settings.arguments as StaffProgrammeModel;
        return MaterialPageRoute(
          builder: (_) => StaffEditProgrammeScreen(programme: programme),
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

