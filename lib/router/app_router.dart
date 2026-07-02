import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_guard.dart';
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
import '../screens/profile/notifications_screen.dart';
import '../providers/notifications_provider.dart';
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
  static const String programmes = '/programmes';
  static const String jobs = '/jobs';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String staffRegister = '/staff-register';

  static const String adminHome = '/admin/home';
  static const String adminJobApplications = '/admin/job-applications';
  static const String adminEmployers = '/admin/employers';
  static const String adminApplicants = '/admin/applicants';
  static const String adminEnrolments = '/admin/enrolments';
  static const String adminActivity = '/admin/activity';
  static const String adminProgrammes = '/admin/programmes';
  static const String adminProfile = '/admin/profile';

  // Staff routes
  static const String staffAddJob = '/staff/jobs/add';
  static const String staffEditJob = '/staff/jobs/edit';
  static const String staffAddProgramme = '/staff/programmes/add';
  static const String staffEditProgramme = '/staff/programmes/edit';
  static const String staffJobs = '/staff/jobs';
  static const String staffProgrammes = '/staff/programmes';
  static const String staffContent = '/staff/content';
  static const String staffProfile = '/staff/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case adminLogin:
        return MaterialPageRoute(
          builder: (_) => const AdminLoginScreen(),
          settings: settings,
        );
      case adminStaffMgmt:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: AdminStaffMgmtScreen()),
          settings: settings,
        );
      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
          settings: settings,
        );
      case staffSignup:
        return MaterialPageRoute(
          builder: (_) => const StaffRegistrationScreen(),
          settings: settings,
        );
      case staffDashboard:
      case staffJobs:
      case staffProgrammes:
      case staffContent:
      case staffProfile:
        return MaterialPageRoute(
          builder: (_) => const LoginGuard(child: StaffShell()),
          settings: settings,
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: settings,
        );
      case home:
      case programmes:
      case jobs:
      case profile:
        return MaterialPageRoute(
          builder: (_) => const LoginGuard(child: AppShell()),
          settings: settings,
        );
      case notifications:
        return MaterialPageRoute(
          builder: (_) => LoginGuard(
            child: Consumer(
              builder: (context, ref, _) {
                final notifications = ref.watch(notificationsProvider);
                return NotificationsScreen(
                  notifications: notifications.map((n) => n.toJson()).toList(),
                );
              },
            ),
          ),
          settings: settings,
        );
      case adminHome:
      case adminActivity:
      case '/admin/performance':
      case adminStaffMgmt:
      case '/admin/tools':
      case adminProfile:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: AdminShell()),
          settings: settings,
        );
      case staffRegister:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: AdminShell()),
          settings: settings,
        );
      case adminEmployers:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: AdminEmployersScreen()),
          settings: settings,
        );

      case adminApplicants:
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: AdminApplicantsScreen()),
          settings: settings,
        );
      case '/admin/job-applications':
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => AuthGuard(
            child: AdminJobApplicationsScreen(
              jobId: args['jobId']!,
              jobTitle: args['jobTitle']!,
            ),
          ),
          settings: settings,
        );
      case adminEnrolments:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => AuthGuard(
            child: AdminEnrolmentsScreen(
              programmeId: args['programmeId']!,
              programmeName: args['programmeName'] ?? 'Programme',
            ),
          ),
          settings: settings,
        );

      case staffAddJob:
        return MaterialPageRoute(
          builder: (_) => const LoginGuard(child: StaffAddJobScreen()),
          settings: settings,
        );
      case staffEditJob:
        final job = settings.arguments as StaffJobModel;
        return MaterialPageRoute(
          builder: (_) => LoginGuard(child: StaffEditJobScreen(job: job)),
          settings: settings,
        );
      case staffAddProgramme:
        return MaterialPageRoute(
          builder: (_) => const LoginGuard(child: StaffAddProgrammeScreen()),
          settings: settings,
        );
      case staffEditProgramme:
        final programme = settings.arguments as StaffProgrammeModel;
        return MaterialPageRoute(
          builder: (_) => LoginGuard(child: StaffEditProgrammeScreen(programme: programme)),
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

