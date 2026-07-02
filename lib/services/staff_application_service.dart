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
          .from('job_applications')
          .select(
          '''
            job_application_id,
            application_status,
            application_date,
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
          .order('application_date', ascending: false);

      return List<StaffApplicationModel>.from(
          response.map((app) => StaffApplicationModel.fromJson({
            'id': app['job_application_id'],
            'status': app['application_status'],
            'applied_at': app['application_date'],
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
          .from('job_applications')
          .update({'application_status': status})
          .eq('job_application_id', applicationId);
      print('✅ Application status updated: $status');
    } catch (e) {
      print('❌ Error updating application status: $e');
      rethrow;
    }
  }
}