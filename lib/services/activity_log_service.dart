import '../models/activity_log_event.dart';

/// MOCK service standing in for INT-013 (SupabaseService — Activity Log,
/// Anonymised).
///
/// INT-013 is logged in the backlog but is currently unassigned and not
/// yet implemented. This class exists purely so the Admin Activity Log
/// screen has something to call. No screen file should ever import
/// Supabase directly — once INT-013 ships, swap the body of
/// [getActivityLog] for a real call into SupabaseService and this file
/// can be deleted.
class ActivityLogService {
  ActivityLogService._internal();
  static final ActivityLogService _instance = ActivityLogService._internal();
  factory ActivityLogService() => _instance;

  /// Returns anonymised activity events, optionally filtered by
  /// 'all' | 'applications' | 'enrollments' | 'staff'.
  ///
  /// No user names, emails, or IDs are ever included in the returned
  /// events.
  Future<List<ActivityLogEvent>> getActivityLog(String filter) async {
    // [INT-013] — Replace the mock data below with a real call, e.g.:
    // return SupabaseService().getActivityLog(filter);
    await Future.delayed(const Duration(milliseconds: 700));

    final events = _mockEvents;

    switch (filter) {
      case 'applications':
        return events
            .where((e) => e.category == ActivityEventCategory.application)
            .toList();
      case 'enrollments':
        return events
            .where((e) => e.category == ActivityEventCategory.enrollment)
            .toList();
      case 'staff':
        return events
            .where((e) =>
                e.category == ActivityEventCategory.staffPending ||
                e.category == ActivityEventCategory.staffApproved ||
                e.category == ActivityEventCategory.staffRejected)
            .toList();
      case 'all':
      default:
        return events;
    }
  }

  static final List<ActivityLogEvent> _mockEvents = [
    ActivityLogEvent(
      type: 'Application submitted',
      description: 'Junior Flutter Developer · TechNova',
      timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
      category: ActivityEventCategory.application,
    ),
    ActivityLogEvent(
      type: 'Programme enrollment',
      description: 'Salesforce Admin Bootcamp · 1 new learner',
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      category: ActivityEventCategory.enrollment,
    ),
    ActivityLogEvent(
      type: 'Staff registration',
      description: 'Microsoft SA · Pending approval',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      category: ActivityEventCategory.staffPending,
    ),
    ActivityLogEvent(
      type: 'Staff approved',
      description: 'Amazon SA account activated',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      category: ActivityEventCategory.staffApproved,
    ),
    ActivityLogEvent(
      type: 'Applications submitted',
      description: 'Data Analyst Trainee · Innovate SA · 5 applications',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      category: ActivityEventCategory.application,
    ),
    ActivityLogEvent(
      type: 'Staff rejected',
      description: 'Unverified company account suspended',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: ActivityEventCategory.staffRejected,
    ),
    ActivityLogEvent(
      type: 'Programme enrollment',
      description: 'Cloud Fundamentals Bootcamp · 3 new learners',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      category: ActivityEventCategory.enrollment,
    ),
    ActivityLogEvent(
      type: 'Application submitted',
      description: 'Cloud Support Engineer · Amazon SA',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      category: ActivityEventCategory.application,
    ),
  ];
}