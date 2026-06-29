import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/screens/home/home_screen.dart';
import 'package:futurepath_employment_hub/screens/programmes/programme_list_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/opportunity_list_screen.dart';
import 'package:futurepath_employment_hub/screens/profile/profile_screen.dart';

import 'package:futurepath_employment_hub/router/app_router.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onSeeAllJobs: () => _onTabTapped(2),
        onSeeAllProgrammes: () => _onTabTapped(1),
        onSearch: (query) => Navigator.pushNamed(
          context,
          AppRouter.searchResults,
          arguments: query,
        ),
      ),
      const ProgrammeListScreen(),
      const OpportunityListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Programmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
