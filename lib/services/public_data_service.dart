import 'package:supabase_flutter/supabase_flutter.dart';

class PublicDataService {
  static final _supabase = Supabase.instance.client;

  /// Returns job applications for a given job ID. 
  /// No PII shown — applicant identity is protected.
  static Future<List<Map<String, dynamic>>> getApplicationsForJob(String jobId) async {
    try {
      final response = await _supabase
          .from('applications')
          .select('id, qualification, status, applied_at, applicant_id')
          .eq('job_id', jobId);

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
          .from('applications')
          .update({'status': newStatus})
          .eq('id', applicationId);
    } catch (e) {
      print('❌ Error updating application status: $e');
      rethrow;
    }
  }

  /// Returns enrolments for a given programme. Returns no PII — applicant
  /// identity is represented only by the anonymised applicant_id_c column.
  static Future<List<Map<String, dynamic>>> getEnrolmentsForProgramme(
    String programmeId) async {
    try {
      final response = await _supabase
          .from('enrolments')
          .select('applicant_id_c, qualification, status')
          .eq('programme_id', programmeId);

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
          .from('enrolments')
          .update({'status': newStatus})
          .eq('applicant_id_c', applicantId);
    } catch (e) {
      print('❌ Error updating enrolment status: $e');
      rethrow;
    }
  }
}
