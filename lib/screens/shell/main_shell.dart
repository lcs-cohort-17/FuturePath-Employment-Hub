import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class MainShell extends StatefulWidget {
  // Expose the global key so any child screen can access this state
  static final GlobalKey<MainShellState> shellKey = GlobalKey<MainShellState>();

  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Method required to change tabs externally
  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    HomeScreen(),
    ProgrammesScreen(),
    JobsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: 'Programmes',
          ),
          NavigationDestination(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
        ],
      ),
    );
  }
}

class ProgrammesScreen extends StatelessWidget {
  const ProgrammesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programmes')),
      body: const Center(
        child: Text(
          'Programmes Screen List View',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs')),
      body: const Center(
        child: Text(
          'Jobs Screen List View',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}