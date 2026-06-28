// TODO: Replace with final service
// This service fetches dashboard stats and activity logs.
// ✅ Uses correct column names: opportunity_status, programme_status, created_by

import 'package:supabase_flutter/supabase_flutter.dart';

class StaffDashboardService {
  static final _supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>> getDashboardStats(String userId) async {
    try {
      // Get jobs count — filter by created_by and opportunity_status
      final jobs = await _supabase
          .from('employment_opportunities')
          .select('opportunity_status')
          .eq('created_by', userId);

      final totalJobs = jobs.length;
      final activeJobs = jobs.where((j) => j['opportunity_status'] == 'open').length;

      // Get programmes count
      final programmes = await _supabase
          .from('training_programmes')
          .select('programme_status')
          .eq('created_by', userId);

      final totalProgrammes = programmes.length;
      final activeProgrammes = programmes.where((p) => p['programme_status'] == 'open').length;

      // Get applications (for jobs created by this staff)
      final applications = await _supabase
          .from('job_applications')
          .select('*, employment_opportunities!inner(created_by)')
          .eq('employment_opportunities.created_by', userId);

      final totalApplications = applications.length;

      // Get enrollments (for programmes created by this staff)
      final enrollments = await _supabase
          .from('programme_enrollments')
          .select('*, training_programmes!inner(created_by)')
          .eq('training_programmes.created_by', userId);

      final totalEnrollments = enrollments.length;
      final completed = enrollments.where((e) => e['status'] == 'completed').length;
      final completionRate = totalEnrollments > 0
          ? (completed / totalEnrollments * 100).round()
          : 0;

      return {
        'total_jobs': totalJobs,
        'active_jobs': activeJobs,
        'total_programmes': totalProgrammes,
        'active_programmes': activeProgrammes,
        'total_applications': totalApplications,
        'total_enrollments': totalEnrollments,
        'completion_rate': completionRate,
      };
    } catch (e) {
      print('❌ Error fetching dashboard stats: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getStaffActivityLog(String userId) async {
    try {
      final response = await _supabase
          .from('staff_activity_log')
          .select('*')
          .eq('staff_id', userId)
          .order('created_at', ascending: false)
          .limit(20);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching activity log: $e');
      return [];
    }
  }
}