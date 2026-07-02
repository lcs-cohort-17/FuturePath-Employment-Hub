// ✅ No PII — only af_id + qualification
// Staff sees anonymous applicant data only.

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/staff_application_model.dart';

class StaffApplicationService {
  static final _supabase = Supabase.instance.client;

  // Returns applications for jobs created by this staff member.
  // ⚠️ Only af_id and highest_qualification are fetched — no names/emails/phones.
  static Future<List<StaffApplicationModel>> getStaffApplications(String staffId) async {
    try {
      final response = await _supabase
          .from('Job_Applications')
          .select(
          '''
            Job_Application_id,
            Application_Status,
            Application_Date,
            "Employment Opportunity"!inner (
              opportunity_id,
              Position_Title,
              Created_By,
              employer_id
            ),
            Applicant!inner (
              id,
              Highest_Qualification
            )
            '''
      )
          .eq('"Employment Opportunity".Created_By', staffId)
          .order('Application_Date', ascending: false);

      return List<StaffApplicationModel>.from(
          response.map((app) => StaffApplicationModel.fromJson({
            'id': app['Job_Application_id'],
            'status': app['Application_Status'],
            'applied_at': app['Application_Date'],
            'cv_url': null, // cv_url not in schema?
            'applicant_id': app['Applicant']['id'].toString(),
            'highest_qualification': app['Applicant']['Highest_Qualification'],
            'position_title': app['Employment Opportunity']['Position_Title'],
            'company_name': 'N/A', // Would need Employer join
          }))
      );
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