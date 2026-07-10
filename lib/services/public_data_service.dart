import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/programme.dart';
import '../models/staff_job_model.dart';
import '../utils/id_generator.dart';

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

  // ─── NEW: Fetch programme enrolments for an applicant ─────────────────

  /// Fetches all programme enrolments for a given applicant ID,
  /// including the related programme details.
  static Future<List<Map<String, dynamic>>> getMyProgrammeEnrolments(int applicantId) async {
    try {
      // ✅ FIXED: Use double quotes and the actual table name with a space
      final response = await _supabase
          .from('Programme_Enrolments')
          .select('''
            Enrolment_id,
            Enrolment_Status,
            Completion_Date,
            "Training Programme" (
              programme_id,
              Programme_Name,
              Programme_Description,
              level,
              duration_months,
              enrolled_count,
              Capacity,
              Programme_Status
            )
          ''')
          .eq('Applicant_id', applicantId)
          .order('Enrolment_Status', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching my programme enrolments: $e');
      return [];
    }
  }

  // ─── NEW: Enrol an applicant into a programme ─────────────────────────

  /// Enrol an applicant into a training programme.
  static Future<void> enrolInProgramme({
    required int applicantId,
    required String programmeId,
    required String status, // 'pending', 'enrolled', 'completed'
  }) async {
    try {
      // ✅ Use the IdGenerator to create a 7‑character ID
      final enrolmentId = IdGenerator.generateEnrolmentId();

      await _supabase.from('Programme_Enrolments').insert({
        'Enrolment_id': enrolmentId,
        'Applicant_id': applicantId,
        'Training_Programme_id': programmeId,
        'Enrolment_Status': status,
        'Completion_Date': null,
        'Result': null,
      });
      print('✅ Enrolment successful: $enrolmentId');
    } catch (e) {
      print('❌ Enrolment failed: $e');
      throw Exception('Failed to enrol: $e');
    }
  }
}