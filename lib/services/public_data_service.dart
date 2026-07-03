import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/programme.dart';
import '../models/staff_job_model.dart';

class PublicDataService {
  static final _supabase = Supabase.instance.client;

  /// Fetches all active training programmes.
  static Future<List<Programme>> getProgrammes() async {
    try {
      final response = await _supabase
          .from('Training Programme')
          .select()
          .order('Start_Date', ascending: true);
      
      return (response as List).map((p) => Programme.fromJson(p)).toList();
    } catch (e) {
      print('❌ Error fetching programmes: $e');
      return [];
    }
  }

  /// Fetches all open employment opportunities.
  static Future<List<StaffJobModel>> getJobs() async {
    try {
      final response = await _supabase
          .from('Employment Opportunity')
          .select('*, Employer(*)')
          .eq('Opportunity_Status', 'open')
          .order('Closing_Date', ascending: true);
      
      return (response as List).map((j) => StaffJobModel.fromJson(j)).toList();
    } catch (e) {
      print('❌ Error fetching jobs: $e');
      return [];
    }
  }

  /// Returns job applications for a given job ID. 
  /// No PII shown — applicant identity is protected.
  static Future<List<Map<String, dynamic>>> getApplicationsForJob(String jobId) async {
    try {
      final response = await _supabase
          .from('Job_Applications')
          .select('Job_Application_id, Application_Status, Application_Date, Applicant_id')
          .eq('Employment_Opportunity_id', jobId);

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
          .from('Job_Applications')
          .update({'Application_Status': newStatus})
          .eq('Job_Application_id', applicationId);
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
          .from('Programme_Enrolments')
          .select('Applicant_id, Enrolment_Status')
          .eq('Training_Programme_id', programmeId);

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
          .from('Programme_Enrolments')
          .update({'Enrolment_Status': newStatus})
          .eq('Applicant_id', applicantId);
    } catch (e) {
      print('❌ Error updating enrolment status: $e');
      rethrow;
    }
  }
}
