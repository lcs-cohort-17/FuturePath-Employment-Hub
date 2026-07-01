//Tentsaolo sprint 2 ticket UIUX016 starts here
// lib/services/admin_dashboard_service.dart
//
// Mock service for UIUX-016 — Admin Dashboard.
// All data is hardcoded mock data.
//
// [INT-012] — Replace fetchStats() body with real Supabase admin stats query.
// [INT-013] — Replace fetchActivityLog() body with real Supabase activity log query.

import 'dart:async';

/// A single stat card value shown on the admin dashboard.
class AdminStat {
  final String label;
  final String value;
  final StatVariant variant;

  const AdminStat({
    required this.label,
    required this.value,
    this.variant = StatVariant.neutral,
  });
}

enum StatVariant { neutral, brand, success, info }

/// Represents one row in the system health section.
class SystemHealthItem {
  final String label;
  final String subtitle;
  final HealthStatus status;

  const SystemHealthItem({
    required this.label,
    required this.subtitle,
    required this.status,
  });
}

enum HealthStatus { ok, warn, error }

/// Represents one entry in the anonymized activity feed.
class ActivityFeedItem {
  final String title;
  final String subtitle;
  final String timeAgo;
  final ActivityCategory category;

  const ActivityFeedItem({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.category,
  });
}

enum ActivityCategory { application, enrolment, staff, system }

/// Aggregated model returned by fetchStats().
class AdminDashboardStats {
  final List<AdminStat> stats;
  final List<SystemHealthItem> health;

  const AdminDashboardStats({
    required this.stats,
    required this.health,
  });
}

class AdminDashboardService {
  // ---------------------------------------------------------------------------
  // [INT-012] — Replace this method body with SupabaseService.fetchAdminStats()
  // ---------------------------------------------------------------------------
  Future<AdminDashboardStats> fetchStats() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return const AdminDashboardStats(
      stats: [
        AdminStat(label: 'Total Users', value: '1,284', variant: StatVariant.neutral),
        AdminStat(label: 'New Today', value: '+23', variant: StatVariant.success),
        AdminStat(label: 'Active Jobs', value: '48', variant: StatVariant.info),
        AdminStat(label: 'Active Programmes', value: '12', variant: StatVariant.neutral),
        AdminStat(label: 'Total Applications', value: '847', variant: StatVariant.brand),
        AdminStat(label: 'Active Employers', value: '9', variant: StatVariant.neutral),
      ],
      health: [
        SystemHealthItem(
          label: 'Supabase',
          subtitle: 'Operational',
          status: HealthStatus.ok,
        ),
        SystemHealthItem(
          label: 'Storage',
          subtitle: '2.4 GB used',
          status: HealthStatus.ok,
        ),
        SystemHealthItem(
          label: 'Edge Fn',
          subtitle: '1 degraded',
          status: HealthStatus.warn,
        ),
        SystemHealthItem(
          label: 'Auth API',
          subtitle: '142ms avg',
          status: HealthStatus.ok,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // [INT-013] — Replace this method body with SupabaseService.fetchActivityLog()
  // ---------------------------------------------------------------------------
  Future<List<ActivityFeedItem>> fetchActivityLog() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return const [
      ActivityFeedItem(
        title: '3 new job applications',
        subtitle: 'Flutter Developer role · no user data shown',
        timeAgo: '2 min ago',
        category: ActivityCategory.application,
      ),
      ActivityFeedItem(
        title: '7 programme enrolments',
        subtitle: 'Salesforce Admin bootcamp',
        timeAgo: '14 min ago',
        category: ActivityCategory.enrolment,
      ),
      ActivityFeedItem(
        title: 'Staff registration pending',
        subtitle: 'Microsoft SA · Awaiting approval',
        timeAgo: '1 hour ago',
        category: ActivityCategory.staff,
      ),
    ];
  }
}
//Tentsaolo sprint 2 ticket UIUX016 ends here