import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'services/auth_services.dart';
import 'package:futurepath/core/theme/app_theme.dart';
import 'package:futurepath/screens/programmes/programme_list_screen.dart';
import 'package:futurepath/screens/programmes/programme_detail_screen.dart';
import 'package:futurepath/screens/programmes/programme_application_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuturePath Employment Hub',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
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
