
import 'package:flutter/material.dart';
import 'package:futurepath/core/theme/app_theme.dart';
import 'package:futurepath/screens/programmes/programme_list_screen.dart';
import 'package:futurepath/screens/programmes/programme_detail_screen.dart';
import 'package:futurepath/screens/programmes/programme_application_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuturePath',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppTheme.background,
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  void _onProgrammeTap(Programme programme) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProgrammeDetailScreen(
          programme: programme,
          onApplyNow: (p) => _onApplyNow(p),
        ),
      ),
    );
  }

  void _onApplyNow(Programme programme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProgrammeApplyScreen(
        programme: programme,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      ProgrammeListScreen(
        onProgrammeTap: _onProgrammeTap,
      ),
      const Center(child: Text('Jobs Screen (UIUX-006)')),
      const Center(child: Text('History Screen (UIUX-007)')),
      const Center(child: Text('Profile Screen')),
    ];

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.mutedText,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Programmes'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
