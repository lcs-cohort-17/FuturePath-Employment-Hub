//UIUX-016 starts here
// lib/screens/admin/admin_dashboard_screen.dart
//
// UIUX-016 — Admin Dashboard (Mobile — Matching Mockups)
// Displays: 6 stat cards, System Health (4 items), Anonymized Activity Feed.
// Loading spinner while fetching. Error state with retry.
//
// [NAV-010] — AdminShell wraps this screen inside the admin BottomNavigationBar.
// [NAV-011] — AdminRoleRouting gates navigation to this screen for admin users only.

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../services/admin_dashboard_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminDashboardService _service = AdminDashboardService();

  AdminDashboardStats? _stats;
  List<ActivityFeedItem>? _feed;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _service.fetchStats(),
        _service.fetchActivityLog(),
      ]);
      if (!mounted) return;
      setState(() {
        _stats = results[0] as AdminDashboardStats;
        _feed = results[1] as List<ActivityFeedItem>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load dashboard data. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: _loading
                  ? const _LoadingState()
                  : _error != null
                  ? _ErrorState(message: _error!, onRetry: _load)
                  : _DashboardBody(
                stats: _stats!,
                feed: _feed!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'FP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'Admin Panel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined,
                  color: AppTheme.mutedText, size: 22),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '2',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOADING STATE
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primary,
        strokeWidth: 2.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR STATE
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.errorLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_outlined,
                  color: AppTheme.error, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.mutedText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD BODY — scrollable content
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  final AdminDashboardStats stats;
  final List<ActivityFeedItem> feed;

  const _DashboardBody({required this.stats, required this.feed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header greeting ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System overview',
                  style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLow,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Section 1: Stat Cards ─────────────────────────────────────────
          const SizedBox(height: 10),
          _StatCardsGrid(stats: stats.stats),

          // ── Section 2: System Health ──────────────────────────────────────
          _SectionHeader(label: 'System Health'),
          _SystemHealthGrid(items: stats.health),

          // ── Section 3: Anonymized Activity Feed ───────────────────────────
          _SectionHeader(label: 'Anonymized Activity', actionLabel: 'Full log ›'),
          ...feed.map((item) => _ActivityFeedTile(item: item)),

          // ── Section 4: Quick Navigation ───────────────────────────────────
          _SectionHeader(label: 'Quick Navigation'),
          _QuickNavGrid(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final String? actionLabel;

  const _SectionHeader({required this.label, this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          if (actionLabel != null)
            Text(
              actionLabel!,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STAT CARDS GRID — 2-column grid of 6 cards
// ─────────────────────────────────────────────────────────────────────────────

class _StatCardsGrid extends StatelessWidget {
  final List<AdminStat> stats;

  const _StatCardsGrid({required this.stats});

  Color _valueColor(StatVariant variant) {
    switch (variant) {
      case StatVariant.brand:
        return AppTheme.primary;
      case StatVariant.success:
        return AppTheme.success;
      case StatVariant.info:
        return AppTheme.info;
      case StatVariant.neutral:
        return AppTheme.textDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, i) {
          final stat = stats[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _valueColor(stat.variant),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SYSTEM HEALTH GRID — 2-column grid of 4 status items
// ─────────────────────────────────────────────────────────────────────────────

class _SystemHealthGrid extends StatelessWidget {
  final List<SystemHealthItem> items;

  const _SystemHealthGrid({required this.items});

  Color _dotColor(HealthStatus status) {
    switch (status) {
      case HealthStatus.ok:
        return AppTheme.success;
      case HealthStatus.warn:
        return AppTheme.warning;
      case HealthStatus.error:
        return AppTheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 7,
          crossAxisSpacing: 7,
          childAspectRatio: 2.8,
        ),
        itemBuilder: (context, i) {
          final item = items[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border, width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _dotColor(item.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppTheme.mutedText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTIVITY FEED TILE
// ─────────────────────────────────────────────────────────────────────────────

class _ActivityFeedTile extends StatelessWidget {
  final ActivityFeedItem item;

  const _ActivityFeedTile({required this.item});

  _ActivityIconProps _iconProps(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.application:
        return _ActivityIconProps(
          icon: Icons.description_outlined,
          bg: AppTheme.successLow,
          fg: AppTheme.success,
        );
      case ActivityCategory.enrolment:
        return _ActivityIconProps(
          icon: Icons.menu_book_outlined,
          bg: AppTheme.infoLow,
          fg: AppTheme.info,
        );
      case ActivityCategory.staff:
        return _ActivityIconProps(
          icon: Icons.person_add_outlined,
          bg: AppTheme.warningLow,
          fg: AppTheme.warning,
        );
      case ActivityCategory.system:
        return _ActivityIconProps(
          icon: Icons.settings_outlined,
          bg: AppTheme.primaryLow,
          fg: AppTheme.primary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = _iconProps(item.category);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: props.bg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(props.icon, color: props.fg, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.timeAgo,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppTheme.subtleText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityIconProps {
  final IconData icon;
  final Color bg;
  final Color fg;
  const _ActivityIconProps({
    required this.icon,
    required this.bg,
    required this.fg,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// QUICK NAVIGATION GRID — 2×2 action cards
// ─────────────────────────────────────────────────────────────────────────────

class _QuickNavGrid extends StatelessWidget {
  const _QuickNavGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickNavItem(
        icon: Icons.list_alt_outlined,
        iconColor: AppTheme.primary,
        label: 'Activity Log',
        subtitle: 'Anonymized events',
        // [NAV-010] / [NAV-011] — Wire onTap to AdminShell tab index 1 (Activity)
        onTap: () {},
      ),
      _QuickNavItem(
        icon: Icons.bar_chart_outlined,
        iconColor: AppTheme.success,
        label: 'Performance',
        subtitle: 'Content analytics',
        // [NAV-010] / [NAV-011] — Wire onTap to AdminShell tab index 2 (Performance)
        onTap: () {},
      ),
      _QuickNavItem(
        icon: Icons.group_outlined,
        iconColor: AppTheme.info,
        label: 'Staff Mgmt',
        subtitle: 'Approve / Reject',
        // [NAV-010] / [NAV-011] — Wire onTap to AdminShell tab index 3 (Staff Mgmt)
        onTap: () {},
      ),
      _QuickNavItem(
        icon: Icons.settings_outlined,
        iconColor: AppTheme.warning,
        label: 'System',
        subtitle: 'Settings & health',
        // [NAV-010] / [NAV-011] — Wire onTap to AdminShell tab index 4 (System/Tools)
        onTap: () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.55,
        ),
        itemBuilder: (context, i) {
          final item = items[i];
          return GestureDetector(
            onTap: item.onTap,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, color: item.iconColor, size: 22),
                  const Spacer(),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickNavItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickNavItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });
}
//UIUX ticket 016 ends here