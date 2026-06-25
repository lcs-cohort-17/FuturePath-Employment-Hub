import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../programmes/programme_list_screen.dart';
import '../jobs/opportunity_list_screen.dart';
import '../profile/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  static final GlobalKey<_AppShellState> globalKey = GlobalKey<_AppShellState>();

  static const int homeTabIndex = 0;
  static const int programmesTabIndex = 1;
  static const int jobsTabIndex = 2;
  static const int profileTabIndex = 3;

  static int get currentIndex => globalKey.currentState?.currentIndex ?? homeTabIndex;

  static void switchTab(int index, {VoidCallback? onSwitched}) {
    final currentState = globalKey.currentState;
    currentState?.switchToTab(index, onSwitched: onSwitched);
  }

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ProgrammeListScreen(),
    OpportunityListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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

  void switchToTab(int index, {VoidCallback? onSwitched}) {
    if (!mounted) return;

    setState(() {
      currentIndex = index;
    });

    if (onSwitched != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onSwitched();
      });
    }
  }
}