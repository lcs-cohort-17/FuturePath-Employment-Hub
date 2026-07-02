import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_profile_provider.dart';
import '../../services/auth_services.dart';

/// Guards admin-only routes.
///
/// Usage: call `AdminGuard.checkAdminAccess(context, ref)` at the top of
/// the route builder for any admin-only screen. It returns true if the
/// current user is authenticated AND has role == 'admin' on their
/// Applicant profile. If access is denied, it schedules the correct
/// redirect automatically.
///
/// NOTE: relies on UserProfileNotifier.loadRealProfile(userId) having
/// already been called (typically right after sign-in) so that
/// ref.read(userProfileProvider) reflects the real Supabase row rather
/// than mockUserProfile.
class AdminGuard {
  static bool checkAdminAccess(BuildContext context, WidgetRef ref) {
    final authService = AuthService();

    // Case 1: Not authenticated -> redirect to Login
    if (!authService.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
                (route) => false,
          );
        }
      });
      return false;
    }

    final profile = ref.read(userProfileProvider);

    // Case 2: Authenticated but not an Admin -> redirect to applicant Home
    if (!profile.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
                (route) => false,
          );
        }
      });
      return false;
    }

    // Case 3: Authenticated Admin -> allow through
    return true;
  }
}