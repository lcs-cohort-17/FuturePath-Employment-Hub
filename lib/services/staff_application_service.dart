import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/staff_application_model.dart';

class StaffApplicationService {
  static final _supabase = Supabase.instance.client;

  // Returns applications for jobs created by this staff member.
  static Future<List<StaffApplicationModel>> getStaffApplications(String staffId) async {
    try {
      final response = await _supabase
          .from('job_applications')
          .select('''
            Job_Application_id,
            application_status,
            application_date,
            "Employment Opportunity"!inner (
              opportunity_id,
              Position_Title,
              Created_By,
              Employer (
                Company_Name
              )
            ),
            Applicant!inner (
              sf_id,
              Highest_Qualification
            )
            ''')
          .eq('"Employment Opportunity".Created_By', staffId)
          .order('application_date', ascending: false);

      return List<StaffApplicationModel>.from(
          response.map((app) {
            final opp = app['Employment Opportunity'] as Map<String, dynamic>;
            final employer = opp['Employer'] as Map<String, dynamic>?;
            final applicant = app['Applicant'] as Map<String, dynamic>;
            return StaffApplicationModel.fromJson({
              'id': app['Job_Application_id'],
              'status': app['application_status'],
              'applied_at': app['application_date'],
              'cv_url': null,
              'applicant_id': applicant['sf_id'] ?? '',
              'highest_qualification': applicant['Highest_Qualification'],
              'position_title': opp['Position_Title'],
              'company_name': employer?['Company_Name'],
              'updated_at': app['application_date'],
            });
          })
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
          .eq('Job_Application_id', applicationId);
      print('✅ Application status updated: $status');
    } catch (e) {
      print('❌ Error updating application status: $e');
      rethrow;
    }
  }
}