import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/home/home_screen.dart';

class AppRouter {
  static const String home = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const _MainShell());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            userName: 'Sipho',
            notificationCount: 4,
            onSearchSubmitted: (q) => debugPrint('Search: $q'),
            onSeeAllJobs: () => debugPrint('See all jobs'),
            onSeeAllProgrammes: () => debugPrint('See all programmes'),
            onJobTap: (job) => debugPrint('Job: ${job.title}'),
            onProgrammeTap: (p) => debugPrint('Programme: ${p.title}'),
          ),
          const _PlaceholderScreen(label: 'Programmes'),
          const _PlaceholderScreen(label: 'Jobs'),
          const _PlaceholderScreen(label: 'Profile'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.card,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: AppTheme.mutedText,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Programmes'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline_rounded), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Text(label, style: const TextStyle(fontSize: 24, color: AppTheme.mutedText)),
      ),
    );
  }
}