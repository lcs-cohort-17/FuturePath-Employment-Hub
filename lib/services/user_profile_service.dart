// lib/services/user_profile_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/models/user_profile.dart';
import '../core/errors/delete_account_error.dart';

/// Service responsible for user profile operations.
///
/// NAV-011 — added [fetchUserProfile] to pull the real Applicant row
/// (including role/status) from Supabase for use by AdminGuard.
///
/// INT-013 — replace the mock [deleteUserAccount] stub with real
/// Supabase calls when that ticket is implemented.
class UserProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetches the Applicant row matching the given Supabase auth user_id
  /// and maps it to a [UserProfile]. Returns null if no matching row
  /// exists (e.g. user authenticated but Applicant record not yet created).
  Future<UserProfile?> fetchUserProfile(String userId) async {
    final row = await _client
        .from('Applicant')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) return null;
    return UserProfile.fromSupabase(row);
  }

  /// Permanently deletes the user's applicant record, all related data
  /// (applications, enrolments — cascade handled by DB foreign keys), and
  /// finally removes the Supabase Auth user.
  ///
  /// Throws [DeleteAccountException] on any failure so the caller can
  /// present a categorised error to the user.
  ///
  /// INT-013 — replace this mock with real Supabase calls:
  ///   1. await supabase.from('Applicant').delete().eq('id', userId); (this is the user_profile_service)
  ///   2. Use a Supabase Edge Function to call the Admin API and delete
  ///      the auth user server-side.
  Future<void> deleteUserAccount(String userId) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1400));

    // To test error states during development, uncomment one block at a time:

    // // No internet:
    // throw const DeleteAccountException(
    //   code: DeleteAccountErrorCode.noInternet,
    //   userMessage: 'No internet connection.',
    //   technicalDetail: 'SocketException: OS Error: Network is unreachable',
    // );

    // // Server error (5xx):
    // throw const DeleteAccountException(
    //   code: DeleteAccountErrorCode.serverError,
    //   userMessage: 'Server error.',
    //   technicalDetail: 'PostgrestException: status 500',
    // );

    // // Auth deletion failed (partial state):
    // throw const DeleteAccountException(
    //   code: DeleteAccountErrorCode.authDeletionFailed,
    //   userMessage: 'Auth deletion failed.',
    //   technicalDetail: 'AuthException: user not found in auth.users',
    // );

    // // Session expired:
    // throw const DeleteAccountException(
    //   code: DeleteAccountErrorCode.sessionExpired,
    //   userMessage: 'Session expired.',
    //   technicalDetail: 'AuthException: JWT expired',
    // );

    // Mock success — INT-013 replaces this with real deletion logic.
    return;
  }
}