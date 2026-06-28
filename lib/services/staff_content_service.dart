// TODO: Replace with final service
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
          .from('employment_opportunities')
          .select()
          .eq('created_by', userId);

      return List<StaffJobModel>.from(response.map((j) => StaffJobModel.fromJson(j)));
    } catch (e) {
      print('❌ Error fetching jobs: $e');
      rethrow;
    }
  }

  static Future<void> createJob(StaffJobModel job) async {
    try {
      final data = job.toJson();
      await _supabase.from('employment_opportunities').insert(data);
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
          .from('employment_opportunities')
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
          .from('employment_opportunities')
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
          .from('training_programmes')
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
      await _supabase.from('training_programmes').insert(data);
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
          .from('training_programmes')
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
          .from('training_programmes')
          .delete()
          .eq('programme_id', programmeId);
      print('✅ Programme deleted');
    } catch (e) {
      print('❌ Error deleting programme: $e');
      rethrow;
    }
  }
}