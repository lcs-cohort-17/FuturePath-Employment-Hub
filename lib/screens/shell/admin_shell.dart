import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/admin_nav_provider.dart';
import '../../router/app_router.dart';
import '../admin/admin_dashboard_screen.dart';
import '../admin/admin_activity_screen.dart';
import '../admin/admin_performance_screen.dart';
import '../admin/admin_staff_mgmt_screen.dart';
import '../admin/admin_system_screen.dart';
import '../admin/admin_profile_screen.dart';

/// The shell for the Admin role, containing the bottom navigation.
/// [NAV-010]
class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  bool _isInit = true;

  final List<Widget> _screens = const [
    AdminDashboardScreen(),
    AdminActivityScreen(),
    AdminPerformanceScreen(),
    AdminStaffMgmtScreen(),
    AdminSystemScreen(),
    AdminProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      final currentRouteName = ModalRoute.of(context)?.settings.name;
      final routeIndices = {
        AppRouter.adminHome: 0,
        AppRouter.adminActivity: 1,
        '/admin/performance': 2,
        AppRouter.adminStaffMgmt: 3,
        '/admin/tools': 4,
        AppRouter.adminProfile: 5,
      };
      if (currentRouteName != null && routeIndices.containsKey(currentRouteName)) {
        final targetIndex = routeIndices[currentRouteName]!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(adminNavProvider.notifier).state = targetIndex;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(adminNavProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(
              color: AppTheme.border,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: AppTheme.surface,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.subtleText,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 8,
          unselectedFontSize: 8,
          iconSize: 18,
          onTap: (index) {
            ref.read(adminNavProvider.notifier).state = index;
            final paths = [
              AppRouter.adminHome,
              AppRouter.adminActivity,
              '/admin/performance',
              AppRouter.adminStaffMgmt,
              '/admin/tools',
              AppRouter.adminProfile,
            ];
            SystemNavigator.routeInformationUpdated(location: paths[index]);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Admin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Performance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'Staff',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Tools',
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
