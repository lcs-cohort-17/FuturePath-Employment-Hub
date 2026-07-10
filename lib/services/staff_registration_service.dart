import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class StaffRegistrationService {
  static final _supabase = Supabase.instance.client;

  /// Registers a new staff member (Business account).
  /// Creates auth user + inserts into applicants table with role='staff', status='pending_approval'.
  static Future<Map<String, dynamic>> registerStaff({
    required String firstName,
    required String lastName,
    required String companyName,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create auth user (email + password only)
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw Exception('Signup failed: No user returned');

      // 2. Prepare data for applicants table (match your exact column names)
      final staffData = {
        'user_id': user.id,
        'First_Name': firstName,
        'Last_Name': lastName,
        'Email': email, // confirm if column is 'email' or 'email_address'
        'role': 'staff',
        'status': 'pending_approval',
        'company_name': companyName,
        'updated_at': DateTime.now().toIso8601String(),
        // sf_id is omitted because it's now nullable and we don't need it
      };

      // 3. Insert into Applicant (NOT upsert)
      await _supabase.from('Applicant').insert(staffData);

      return {
        'success': true,
        'user_id': user.id,
        'status': 'pending_approval',
      };
    } catch (e) {
      // Print full error for debugging
      print('❌ Staff registration error: $e');
      // Re-throw so the UI can handle it
      rethrow;
    }
  }

  /// Fetches all staff members with 'pending_approval' status.
  static Future<List<Map<String, dynamic>>> getPendingStaff() async {
    try {
      final response = await _supabase
          .from('Applicant')
          .select()
          .eq('role', 'staff')
          .eq('status', 'pending_approval');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching pending staff: $e');
      rethrow;
    }
  }

  /// Updates a staff member's status (active/suspended).
  static Future<void> updateStaffStatus(String userId, String status) async {
    try {
      await _supabase
          .from('Applicant')
          .update({'status': status})
          .eq('user_id', userId);
    } catch (e) {
      print('❌ Error updating staff status: $e');
      rethrow;
    }
  }

  /// Checks the role and status of a user after login.
  static Future<Map<String, dynamic>?> checkUserRole(String userId) async {
    try {
      final data = await _supabase
          .from('Applicant')
          .select('role, status')
          .eq('user_id', userId)
          .maybeSingle(); // Use maybeSingle to avoid throwing if not found

      return data;
    } catch (e) {
      print('❌ Error checking user role: $e');
      return null;
    }
  }
}