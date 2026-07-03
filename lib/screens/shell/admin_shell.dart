import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/admin_nav_provider.dart';
import '../admin/admin_dashboard_screen.dart';
import '../admin/admin_activity_screen.dart';
import '../admin/admin_applicants_screen.dart';
import '../admin/admin_programmes_screen.dart';
import '../admin/admin_profile_screen.dart';
import '../admin/admin_staff_mgmt_screen.dart';

/// The shell for the Admin role, containing the bottom navigation.
/// [NAV-010]
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key});

  final List<Widget> _screens = const [
    AdminDashboardScreen(),
    AdminActivityScreen(),
    AdminProgrammesScreen(),
    AdminStaffMgmtScreen(),
    AdminApplicantsScreen(),
    AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminNavProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(adminNavProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.surface,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.mutedText,
          selectedFontSize: 9,
          unselectedFontSize: 9,
          iconSize: 20,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Programmes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'Staff Mgmt',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Applicants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
