import 'package:flutter/material.dart';
import '../admin/admin_dashboard_screen.dart';
import '../admin/admin_activity_log_screen.dart';
import '../admin/admin_performance_screen.dart';
import '../admin/admin_staff_management_screen.dart';
import '../admin/admin_system_settings_screen.dart';
import '../admin/admin_profile_screen.dart';


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminActivityLogScreen(),
    const AdminPerformanceScreen(),
    const AdminStaffManagementScreen(),
    const AdminSystemSettingsScreen(),
    const AdminProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Admin',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Activity',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart),
      label: 'Performance',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Staff',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Tools',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

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
        },
        items: _bottomNavItems,
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xFFE03A2F),
        unselectedItemColor: const Color(0xFF5C5A57),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
