// TODO: Replace with final design (PO-UIUX-008)
// Placeholder staff shell with 5 bottom navigation tabs.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../router/app_router.dart';
import 'staff_dashboard.dart';
import 'staff_manage_jobs.dart';
import 'staff_manage_programmes.dart';
import 'staff_content.dart';
import 'staff_profile.dart';

class StaffShell extends StatefulWidget {
  const StaffShell({super.key});

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  int _selectedIndex = 0;
  bool _isInit = true;

  static const List<Widget> _screens = [
    StaffDashboard(),
    StaffManageJobs(),
    StaffManageProgrammes(),
    StaffContent(),
    StaffProfile(),
  ];

  static const List<String> _labels = [
    'Dashboard',
    'Jobs',
    'Programmes',
    'Content',
    'Profile',
  ];

  static const List<IconData> _icons = [
    Icons.dashboard,
    Icons.work,
    Icons.book,
    Icons.analytics,
    Icons.person,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      final currentRouteName = ModalRoute.of(context)?.settings.name;
      final routeIndices = {
        AppRouter.staffDashboard: 0,
        AppRouter.staffJobs: 1,
        AppRouter.staffProgrammes: 2,
        AppRouter.staffContent: 3,
        AppRouter.staffProfile: 4,
      };
      if (currentRouteName != null && routeIndices.containsKey(currentRouteName)) {
        _selectedIndex = routeIndices[currentRouteName]!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          final paths = [
            AppRouter.staffDashboard,
            AppRouter.staffJobs,
            AppRouter.staffProgrammes,
            AppRouter.staffContent,
            AppRouter.staffProfile,
          ];
          SystemNavigator.routeInformationUpdated(location: paths[index]);
        },
        type: BottomNavigationBarType.fixed,
        items: List.generate(5, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_icons[index]),
            label: _labels[index],
          );
        }),
        selectedItemColor: const Color(0xFFE03A2F),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1A1C1E),
      ),
    );
  }
}