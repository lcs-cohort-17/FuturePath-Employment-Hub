// TODO: Replace with final design (PO-UIUX-008)
// Placeholder staff shell with 5 bottom navigation tabs.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/notifications_provider.dart';
import 'staff_dashboard.dart';
import 'staff_manage_jobs.dart';
import 'staff_manage_programmes.dart';
import 'staff_content.dart';
import 'staff_profile.dart';

class StaffShell extends ConsumerStatefulWidget {
  const StaffShell({super.key});

  @override
  ConsumerState<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends ConsumerState<StaffShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      await ref.read(userProfileProvider.notifier).fetchProfile(user.id);
      
      // Initialize staff notifications
      ref.read(notificationsProvider.notifier).initStaffRealtime();
    }
  }

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