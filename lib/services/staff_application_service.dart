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
            id,
            status,
            applied_at,
            cv_url,
            employment_opportunities!inner (
              id,
              title,
              created_by,
              company_name
            ),
            applicants!inner (
              af_id,
              highest_qualification
            )
            '''
      )
          .eq('employment_opportunities.created_by', staffId)
          .order('applied_at', ascending: false);

      return List<StaffApplicationModel>.from(
          response.map((app) => StaffApplicationModel.fromJson({
            'id': app['id'],
            'status': app['status'],
            'applied_at': app['applied_at'],
            'cv_url': app['cv_url'],
            'applicant_id': app['applicants']['af_id'],
            'highest_qualification': app['applicants']['highest_qualification'],
            'position_title': app['employment_opportunities']['title'],
            'company_name': app['employment_opportunities']['company_name'],
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
          .update({'status': status})
          .eq('id', applicationId);
      print('✅ Application status updated: $status');
    } catch (e) {
      print('❌ Error updating application status: $e');
      rethrow;
    }
  }
}