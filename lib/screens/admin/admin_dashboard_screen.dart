import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/loading_widget.dart';
import '../shell/main_shell.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<AdminProvider>(
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
                // System overview header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'System overview',
                        style: TextStyle(
                          color: Color(0xFF9E9B96),
                          fontSize: 11,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Admin Dashboard',
                            style: TextStyle(
                              color: Color(0xFFF0EDE8),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE03A2F).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'ADMIN',
                              style: TextStyle(
                                color: Color(0xFFE03A2F),
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

                // Stats cards - 2x3 grid
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
                        number: provider.totalUsers?.toString() ?? '0',
                        label: 'Total Users',
                        color: StatCardColor.neutral,
                      ),
                      StatCard(
                        number: provider.newUsersToday?.toString() ?? '0',
                        label: 'New Today',
                        color: StatCardColor.green,
                      ),
                      StatCard(
                        number: provider.activeJobs?.toString() ?? '0',
                        label: 'Active Jobs',
                        color: StatCardColor.blue,
                      ),
                      StatCard(
                        number: provider.activeProgrammes?.toString() ?? '0',
                        label: 'Active Programmes',
                        color: StatCardColor.neutral,
                      ),
                      StatCard(
                        number: provider.totalApplications?.toString() ?? '0',
                        label: 'Total Applications',
                        color: StatCardColor.red,
                      ),
                      StatCard(
                        number: provider.activeEmployers?.toString() ?? '0',
                        label: 'Active Employers',
                        color: StatCardColor.neutral,
                      ),
                    ],
                  ),
                ),

                // System Health
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE03A2F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'System Health',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Health cards - 2x2 grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 7,
                    childAspectRatio: 2.8,
                    children: [
                      _HealthCard(
                        dotColor: const Color(0xFF2ECC8A),
                        title: 'Supabase',
                        subtitle: 'Operational',
                      ),
                      _HealthCard(
                        dotColor: const Color(0xFF2ECC8A),
                        title: 'Storage',
                        subtitle: '2.4 GB used',
                      ),
                      _HealthCard(
                        dotColor: const Color(0xFFF5A623),
                        title: 'Edge Fn',
                        subtitle: '1 degraded',
                      ),
                      _HealthCard(
                        dotColor: const Color(0xFF2ECC8A),
                        title: 'Auth API',
                        subtitle: '142ms avg',
                      ),
                    ],
                  ),
                ),

                // Anonymized Activity
                 Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Color(0xFFE03A2F),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Anonymized Activity',
                            style: TextStyle(
                              color: Color(0xFFF0EDE8),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Full log ›',
                        style: TextStyle(
                          color: Color(0xFFE03A2F),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // Activity feed items
                _ActivityFeedItem(
                  icon: Icons.file_copy,
                  iconColor: const Color(0xFF2ECC8A),
                  title: '3 new job applications',
                  subtitle: 'Flutter Developer role · no user data shown',
                  time: '2 min ago',
                ),
                _ActivityFeedItem(
                  icon: Icons.book,
                  iconColor: const Color(0xFF4A9EE8),
                  title: '7 programme enrolments',
                  subtitle: 'Salesforce Admin bootcamp',
                  time: '14 min ago',
                ),
                _ActivityFeedItem(
                  icon: Icons.person_add,
                  iconColor: const Color(0xFFF5A623),
                  title: 'Staff registration: John Smith',
                  subtitle: 'Microsoft SA · Pending approval',
                  time: '1 hour ago',
                ),

                // Quick Navigation
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE03A2F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Quick Navigation',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Navigation Cards
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
                      _QuickNavCard(
                        icon: Icons.list,
                        iconColor: const Color(0xFFE03A2F),
                        title: 'Activity Log',
                        subtitle: 'Anonymized events',
                        onTap: () {
                          print('🟢 Tapped Activity Log');
                          print('🔑 mainShellKey: $mainShellKey');
                          print('📍 currentState: ${mainShellKey.currentState}');
                          mainShellKey.currentState?.changeTab(1);
                        },
                      ),
                      _QuickNavCard(
                        icon: Icons.bar_chart,
                        iconColor: const Color(0xFF2ECC8A),
                        title: 'Performance',
                        subtitle: 'Content analytics',
                        onTap: () {
                          print('🟢 Tapped Performance');
                          mainShellKey.currentState?.changeTab(2);
                        },
                      ),
                      _QuickNavCard(
                        icon: Icons.people,
                        iconColor: const Color(0xFF4A9EE8),
                        title: 'Staff Mgmt',
                        subtitle: 'Approve / Reject',
                        onTap: () {
                          print('🟢 Tapped Staff Mgmt');
                          mainShellKey.currentState?.changeTab(3);
                        },
                      ),
                      _QuickNavCard(
                        icon: Icons.settings,
                        iconColor: const Color(0xFFF5A623),
                        title: 'System',
                        subtitle: 'Settings & health',
                        onTap: () {
                          print('🟢 Tapped System');
                          mainShellKey.currentState?.changeTab(4);
                        },
                      ),
                      _QuickNavCard(
                        icon: Icons.person,
                        iconColor: const Color(0xFF4A9EE8),
                        title: 'Profile',
                        subtitle: 'View your account',
                        onTap: () {
                          print('🟢 Tapped Profile');
                          mainShellKey.currentState?.changeTab(5);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Health Card Widget
class _HealthCard extends StatelessWidget {
  final Color dotColor;
  final String title;
  final String subtitle;

  const _HealthCard({
    required this.dotColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFF0EDE8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF9E9B96),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Activity Feed Item Widget
class _ActivityFeedItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityFeedItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFF0EDE8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF9E9B96),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Color(0xFF5C5A57),
                      fontSize: 9,
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

// Quick Navigation Card Widget
class _QuickNavCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickNavCard({
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