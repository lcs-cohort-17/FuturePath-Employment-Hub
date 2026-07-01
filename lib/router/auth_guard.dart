import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/user_profile_provider.dart';
import 'app_router.dart';

class AuthGuard {
  /// Evaluates routing access based on auth state and roles.
  /// 
  /// Returns a redirect route name if access is denied, 
  /// or null if the user is allowed to proceed.
  static String? getRedirect(WidgetRef ref, String? routeName) {
    final authService = ref.read(authServiceProvider);
    final userProfile = ref.read(userProfileProvider);

    final bool isAdminRoute = routeName != null && routeName.startsWith('/admin');

    // Requirement 1: Check authentication state
    if (isAdminRoute && !authService.isLoggedIn) {
      // Unauthenticated users targeting an admin route must be redirected to the Login screen.
      return AppRouter.login;
    }

    // Requirement 2: Check custom role field ('Role_c' / role)
    if (isAdminRoute) {
      if (userProfile.role != 'Admin') {
        // Non-admin authenticated users targeting an admin route must be redirected to the applicant Home screen.
        return AppRouter.home;
      }
    }

    // Admin users targeting an admin route must be allowed to proceed.
    return null; 
  }
}
