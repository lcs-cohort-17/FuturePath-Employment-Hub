import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../router/app_router.dart';
import '../home/home_screen.dart';
import '../programmes/programme_list_screen.dart';
import '../jobs/job_list_screen.dart';
import '../profile/profile_screen.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;
  bool _isInit = true;

  final List<Widget> screens = const [
    HomeScreen(),
    ProgrammeListScreen(),
    OpportunityListScreen(),
    ProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isInit = false;
      final currentRouteName = ModalRoute.of(context)?.settings.name;
      final routeIndices = {
        AppRouter.home: 0,
        AppRouter.programmes: 1,
        AppRouter.jobs: 2,
        AppRouter.profile: 3,
      };
      if (currentRouteName != null && routeIndices.containsKey(currentRouteName)) {
        currentIndex = routeIndices[currentRouteName]!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
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
            setState(() {
              currentIndex = index;
            });
            final paths = [
              AppRouter.home,
              AppRouter.programmes,
              AppRouter.jobs,
              AppRouter.profile,
            ];
            SystemNavigator.routeInformationUpdated(location: paths[index]);
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
      ),
    );
  }
}