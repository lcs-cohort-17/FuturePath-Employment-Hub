// lib/services/staff_application_service.dart
// Fetches applications for staff with anonymised data + CV + motivational letter download link

import 'package:supabase_flutter/supabase_flutter.dart';

class StaffApplicationService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getStaffApplications(String staffId) async {
    try {
      final response = await _supabase
          .from('Job_Applications')
          .select('''
            Job_Application_id,
            Application_Status,
            Application_Date,
            cv_url,
            motivational_letter_url,
            consent_given,
            "Employment Opportunity"!inner (
              opportunity_id,
              Position_Title,
              Created_By
            ),
            Applicant!inner (
              id,
              Highest_Qualification
            )
          ''')
          .eq('"Employment Opportunity".Created_By', staffId)
          .order('Application_Date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching staff applications: $e');
      rethrow;
    }
  }

  static Future<void> updateApplicationStatus(String applicationId, String status) async {
    try {
      await _supabase
          .from('Job_Applications')
          .update({'Application_Status': status})
          .eq('Job_Application_id', applicationId);
      print('✅ Application status updated: $status');
    } catch (e) {
      print('❌ Error updating application status: $e');
      rethrow;
    }
  }

  // ─── DELETE APPLICATION ─────────────────────────────────────────────────

  static Future<void> deleteApplication(String applicationId) async {
    try {
      await _supabase
          .from('Job_Applications')
          .delete()
          .eq('Job_Application_id', applicationId);
      print('✅ Application deleted: $applicationId');
    } catch (e) {
      print('❌ Error deleting application: $e');
      rethrow;
    }
  }
}