import 'package:supabase_flutter/supabase_flutter.dart';

class PublicDataService {
  static final _supabase = Supabase.instance.client;

  /// Returns job applications for a given job ID. 
  /// No PII shown — applicant identity is protected.
  static Future<List<Map<String, dynamic>>> getApplicationsForJob(String jobId) async {
    try {
      final response = await _supabase
          .from('job_applications')
          .select('job_application_id, application_status, application_date, applicant_id')
          .eq('employment_opportunity_id', jobId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching job applications: $e');
      return [];
    }
  }

  /// Updates the status of a job application.
  static Future<void> updateApplicationStatus(
    String applicationId,
    String newStatus,
  ) async {
    try {
      await _supabase
          .from('job_applications')
          .update({'application_status': newStatus})
          .eq('job_application_id', applicationId);
    } catch (e) {
      print('❌ Error updating application status: $e');
      rethrow;
    }
  }

  /// Returns enrolments for a given programme. Returns no PII — applicant
  /// identity is represented only by the anonymised applicant_id column.
  static Future<List<Map<String, dynamic>>> getEnrolmentsForProgramme(
    String programmeId) async {
    try {
      final response = await _supabase
          .from('programme_enrollments')
          .select('applicant_id, enrolment_status')
          .eq('training_programme_id', programmeId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching enrolments: $e');
      return [];
    }
  }

  /// Updates the status of a single enrolment. Uses only the anonymised
  /// applicant ID — never PII.
  static Future<void> updateEnrolmentStatus(
    String applicantId, String newStatus) async {
    try {
      await _supabase
          .from('programme_enrollments')
          .update({'enrolment_status': newStatus})
          .eq('applicant_id', applicantId);
    } catch (e) {
      print('❌ Error updating enrolment status: $e');
      rethrow;
    }
  }
}
