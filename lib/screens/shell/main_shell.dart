import 'package:flutter/material.dart';
import '../../router/app_router.dart';
import '../home/home_screen.dart';
import '../programmes/programme_list_screen.dart';
import '../jobs/opportunity_list_screen.dart';
import '../jobs/opportunity_detail_screen.dart';
import '../profile/profile_screen.dart';

import '../../router/app_router.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        onSeeAllJobs: () => setState(() => currentIndex = 2),
        onSeeAllProgrammes: () => setState(() => currentIndex = 1),
        onJobTap: (job) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OpportunityDetailScreen(),
            ),
          );
        },
        onProgrammeTap: (prog) {
          setState(() => currentIndex = 1);
        },
        onNotificationsTap: () {
          Navigator.pushNamed(context, AppRouter.notifications);
        },
        onSearch: (query) {
          Navigator.pushNamed(context, AppRouter.searchResults);
        },
      ),
      const ProgrammeListScreen(),
      const OpportunityListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
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