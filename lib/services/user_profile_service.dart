import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../core/errors/delete_account_error.dart';

/// Service responsible for user profile operations.
class UserProfileService {
  final _supabase = Supabase.instance.client;

  /// Fetches the user profile from the 'Applicant' table.
  Future<UserProfile?> fetchUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('Applicant')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) return null;

      return UserProfile(
        id: data['id']?.toString() ?? '', // bigint ID as String
        userId: data['user_id'], // UUID
        name: '${data['First_Name'] ?? ''} ${data['Last_Name'] ?? ''}'.trim(),
        displayName: '${data['First_Name'] ?? ''} ${data['Last_Name'] ?? ''}'.trim(),
        location: data['Residential_Area'] ?? '',
        employmentStatus: data['Current_Employment_Status'] ?? 'Unemployed',
        isHired: false,
        email: data['Email'] ?? '',
        phone: data['contact_number'] ?? '',
        idNumber: data['id_number'] ?? '',
        dateOfBirth: data['Date_Of_Birth'] ?? '',
        gender: data['Gender'] ?? '',
        education: data['Highest_Qualification'] ?? '',
        skills: List<String>.from(data['Skills'] ?? []),
      );
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      return null;
    }
  }

  /// Permanently deletes the user's applicant record, all related data
  /// (applications, enrolments — cascade handled by DB foreign keys), and
  /// finally removes the Supabase Auth user.
  ///
  /// Throws [DeleteAccountException] on any failure so the caller can
  /// present a categorised error to the user.
  ///
  /// INT-013 — replace this mock with real Supabase calls:
  ///   1. await supabase.from('Applicant').delete().eq('id', userId);
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