// lib/services/staff_content_service.dart
// ✅ Uses actual column names from both tables

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/staff_job_model.dart';
import '../models/staff_programme_model.dart';

class StaffContentService {
  static final _supabase = Supabase.instance.client;

  // --- JOBS ---

  static Future<List<StaffJobModel>> getMyJobs(String userId) async {
    try {
      final response = await _supabase
          .from('Employment Opportunity')
          .select()
          .eq('Created_By', userId);

      return List<StaffJobModel>.from(response.map((j) => StaffJobModel.fromJson(j)));
    } catch (e) {
      print('❌ Error fetching jobs: $e');
      rethrow;
    }
  }

  static Future<void> createJob(StaffJobModel job) async {
    try {
      final data = job.toJson();
      await _supabase.from('Employment Opportunity').insert(data);
      print('✅ Job created');
    } catch (e) {
      print('❌ Error creating job: $e');
      rethrow;
    }
  }

  static Future<void> updateJob(String jobId, StaffJobModel job) async {
    try {
      final data = job.toJson();
      await _supabase
          .from('Employment Opportunity')
          .update(data)
          .eq('opportunity_id', jobId);
      print('✅ Job updated');
    } catch (e) {
      print('❌ Error updating job: $e');
      rethrow;
    }
  }

  static Future<void> deleteJob(String jobId) async {
    try {
      await _supabase
          .from('Employment Opportunity')
          .delete()
          .eq('opportunity_id', jobId);
      print('✅ Job deleted');
    } catch (e) {
      print('❌ Error deleting job: $e');
      rethrow;
    }
  }

  // --- PROGRAMMES ---

  static Future<List<StaffProgrammeModel>> getMyProgrammes(String userId) async {
    try {
      final response = await _supabase
          .from('Training Programme')
          .select()
          .eq('created_by', userId);

      return List<StaffProgrammeModel>.from(response.map((p) => StaffProgrammeModel.fromJson(p)));
    } catch (e) {
      print('❌ Error fetching programmes: $e');
      rethrow;
    }
  }

  static Future<void> createProgramme(StaffProgrammeModel programme) async {
    try {
      final data = programme.toJson();
      await _supabase.from('Training Programme').insert(data);
      print('✅ Programme created');
    } catch (e) {
      print('❌ Error creating programme: $e');
      rethrow;
    }
  }

  static Future<void> updateProgramme(String programmeId, StaffProgrammeModel programme) async {
    try {
      final data = programme.toJson();
      await _supabase
          .from('Training Programme')
          .update(data)
          .eq('programme_id', programmeId);
      print('✅ Programme updated');
    } catch (e) {
      print('❌ Error updating programme: $e');
      rethrow;
    }
  }

  static Future<void> deleteProgramme(String programmeId) async {
    try {
      await _supabase
          .from('Training Programme')
          .delete()
          .eq('programme_id', programmeId);
      print('✅ Programme deleted');
    } catch (e) {
      print('❌ Error deleting programme: $e');
      rethrow;
    }
  }

  // ─── ENROLMENTS ───────────────────────────────────────────────────────────

  /// Get all programme enrolments for programmes created by this staff member.
  static Future<List<Map<String, dynamic>>> getStaffEnrolments(String staffId) async {
    try {
      // ✅ FIXED: Table name with space MUST be in double quotes
      final response = await _supabase
          .from('Programme_Enrolments')
          .select('''
            Enrolment_id,
            Enrolment_Status,
            Completion_Date,
            Applicant_id,
            "Training Programme" (
              programme_id,
              Programme_Name,
              created_by,
              level,
              duration_months,
              enrolled_count,
              Capacity,
              Programme_Status
            )
          ''')
          .eq('"Training Programme".created_by', staffId)
          .order('Enrolment_Status', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching staff enrolments: $e');
      rethrow;
    }
  }

  /// Update enrolment status.
  static Future<void> updateEnrolmentStatus(String enrolmentId, String status) async {
    try {
      await _supabase
          .from('Programme_Enrolments')
          .update({'Enrolment_Status': status})
          .eq('Enrolment_id', enrolmentId);
      print('✅ Enrolment status updated: $status');
    } catch (e) {
      print('❌ Error updating enrolment status: $e');
      rethrow;
    }
  }

  /// Delete an enrolment.
  static Future<void> deleteEnrolment(String enrolmentId) async {
    try {
      await _supabase
          .from('Programme_Enrolments')
          .delete()
          .eq('Enrolment_id', enrolmentId);
      print('✅ Enrolment deleted: $enrolmentId');
    } catch (e) {
      print('❌ Error deleting enrolment: $e');
      rethrow;
    }
  }
}