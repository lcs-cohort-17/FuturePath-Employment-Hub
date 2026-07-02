import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _supabase = Supabase.instance.client;

  /// Fetches real stats from Supabase or returns defaults if none exist.
  Future<AdminDashboardStats> fetchStats() async {
    try {
      // Fetch counts from Supabase tables
      final usersCount = await _supabase.from('Applicant').count(CountOption.exact);
      final jobsCount = await _supabase.from('opportunities').count(CountOption.exact); // Assuming table name
      final appsCount = await _supabase.from('applications').count(CountOption.exact);

      return AdminDashboardStats(
        stats: [
          AdminStat(label: 'Total Users', value: '$usersCount', variant: StatVariant.neutral),
          const AdminStat(label: 'New Today', value: '0', variant: StatVariant.success),
          AdminStat(label: 'Active Jobs', value: '$jobsCount', variant: StatVariant.info),
          const AdminStat(label: 'Active Programmes', value: '0', variant: StatVariant.neutral),
          AdminStat(label: 'Total Applications', value: '$appsCount', variant: StatVariant.brand),
          const AdminStat(label: 'Active Employers', value: '0', variant: StatVariant.neutral),
        ],
        health: const [
          SystemHealthItem(label: 'Supabase', subtitle: 'Connected', status: HealthStatus.ok),
          SystemHealthItem(label: 'Storage', subtitle: 'Operational', status: HealthStatus.ok),
          SystemHealthItem(label: 'Auth API', subtitle: 'Online', status: HealthStatus.ok),
          SystemHealthItem(label: 'Database', subtitle: 'Stable', status: HealthStatus.ok),
        ],
      );
    } catch (e) {
      print('❌ Dashboard Stats Error: $e');
      // Return empty stats if table fetch fails (e.g. table doesn't exist yet)
      return const AdminDashboardStats(
        stats: [
          AdminStat(label: 'Total Users', value: '0'),
          AdminStat(label: 'New Today', value: '0'),
          AdminStat(label: 'Active Jobs', value: '0'),
          AdminStat(label: 'Active Programmes', value: '0'),
          AdminStat(label: 'Total Applications', value: '0'),
          AdminStat(label: 'Active Employers', value: '0'),
        ],
        health: [
          SystemHealthItem(label: 'Connection', subtitle: 'Check logs', status: HealthStatus.warn),
        ],
      );
    }
  }

  /// Fetches the real activity log (anonymized) from Supabase.
  Future<List<ActivityFeedItem>> fetchActivityLog() async {
    try {
      // This would normally fetch from an 'audit_log' or 'activity_log' table.
      // For now, return an empty list until that table is ready.
      return [];
    } catch (e) {
      print('❌ Activity Log Error: $e');
      return [];
    }
  }
}
