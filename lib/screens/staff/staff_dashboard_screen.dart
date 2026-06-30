import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/staff_provider.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/job_card.dart';
import '../../core/widgets/loading_widget.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<StaffProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Loading dashboard...');
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadDashboardData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE03A2F),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          color: Color(0xFF9E9B96),
                          fontSize: 11,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            provider.staffName ?? 'Staff',
                            style: const TextStyle(
                              color: Color(0xFFF0EDE8),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A9EE8).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'STAFF',
                              style: TextStyle(
                                color: Color(0xFF4A9EE8),
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Stats cards - 2x2 grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.4,
                    children: [
                      StatCard(
                        number: provider.totalJobs?.toString() ?? '0',
                        label: 'Total Jobs',
                        color: StatCardColor.neutral,
                      ),
                      StatCard(
                        number: provider.activeJobs?.toString() ?? '0',
                        label: 'Active Jobs',
                        color: StatCardColor.green,
                      ),
                      StatCard(
                        number: provider.totalProgrammes?.toString() ?? '0',
                        label: 'Total Programmes',
                        color: StatCardColor.neutral,
                      ),
                      StatCard(
                        number: provider.activeProgrammes?.toString() ?? '0',
                        label: 'Active Programmes',
                        color: StatCardColor.red,
                      ),
                    ],
                  ),
                ),

                // Quick Actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE03A2F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Action Cards - 2x2 grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.3,
                    children: [
                      _QuickActionCard(
                        icon: Icons.add,
                        iconColor: const Color(0xFFE03A2F),
                        title: 'Add Job',
                        subtitle: 'Post a new vacancy',
                        onTap: () {
                          Navigator.pushNamed(context, '/staff/jobs/add');
                        },
                      ),
                      _QuickActionCard(
                        icon: Icons.book_online,
                        iconColor: const Color(0xFF4A9EE8),
                        title: 'Add Programme',
                        subtitle: 'Create training',
                        onTap: () {
                          Navigator.pushNamed(context, '/staff/programmes/add');
                        },
                      ),
                      _QuickActionCard(
                        icon: Icons.bar_chart,
                        iconColor: const Color(0xFF2ECC8A),
                        title: 'View Analytics',
                        subtitle: 'Aggregated only',
                        onTap: () {
                          Navigator.pushNamed(context, '/staff/activity');
                        },
                      ),
                      _QuickActionCard(
                        icon: Icons.description,
                        iconColor: const Color(0xFFF5A623),
                        title: 'My Activity',
                        subtitle: 'Your action log',
                        onTap: () {
                          Navigator.pushNamed(context, '/staff/activity');
                        },
                      ),
                    ],
                  ),
                ),

                // Recent Uploads
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE03A2F),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Recent Uploads',
                            style: TextStyle(
                              color: Color(0xFFF0EDE8),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Manage ›',
                        style: TextStyle(
                          color: Color(0xFFE03A2F),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // Recent job cards - FIXED: removed unnecessary null check
                for (var job in provider.recentJobs)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: JobCard(
                      companyInitials: 'AM',
                      companyColor: const Color(0xFF4A9EE8).withValues(alpha: 0.2),
                      title: job['title'] ?? '',
                      company: job['company'] ?? '',
                      tags: List<String>.from(job['skills'] ?? []),
                      meta: job['meta'] ?? '',
                      badgeText: job['status'] ?? 'Active',
                      badgeType: BadgeType.active,
                    ),
                  ),

                // Privacy footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF5C5A57),
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Applicant personal data is never visible to staff',
                        style: TextStyle(
                          color: Color(0xFF5C5A57),
                          fontSize: 10,
                        ),
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

// Quick Action Card Widget
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF0EDE8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF9E9B96),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}