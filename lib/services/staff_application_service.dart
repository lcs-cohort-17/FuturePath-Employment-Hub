// lib/services/staff_application_service.dart
// ✅ Updated to fetch CV URL and anonymised applicant data

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_application_model.dart';

class StaffApplicationService {
  static final _supabase = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getStaffApplications(String staffId) async {
    try {
      final response = await _supabase
          .from('Job_Applications')
          .select(
          '''
            Job_Application_id,
            Application_Status,
            Application_Date,
            cv_url,
            consent_given,
            Employment_Opportunity!inner (
              opportunity_id,
              Position_Title,
              Created_By
            ),
            Applicant!inner (
              id,
              Highest_Qualification
            )
            '''
      )
          .eq('Employment_Opportunity.Created_By', staffId)
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
}