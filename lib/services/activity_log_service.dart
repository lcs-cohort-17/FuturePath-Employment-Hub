import '../models/activity_log_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityLogService {
  ActivityLogService._internal();
  static final ActivityLogService _instance = ActivityLogService._internal();
  factory ActivityLogService() => _instance;

  final _supabase = Supabase.instance.client;

  /// Returns anonymised activity events, optionally filtered by
  /// 'all' | 'applications' | 'enrollments' | 'staff'.
  Future<List<ActivityLogEvent>> getActivityLog(String filter) async {
    try {
      // This would normally fetch from an 'audit_log' or 'activity_log' table.
      // For now, return an empty list until that table is ready in Supabase.
      return [];
    } catch (e) {
      print('❌ Activity Log Service Error: $e');
      return [];
    }
  }
}
