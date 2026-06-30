import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/staff/staff_dashboard_screen.dart';
import 'screens/staff/staff_manage_jobs_screen.dart';
import 'screens/staff/staff_manage_programmes_screen.dart';
import 'providers/staff_provider.dart';
import 'providers/job_provider.dart';
import 'providers/programme_provider.dart';

void main() {
  runApp(const FuturePathApp());
}

class FuturePathApp extends StatelessWidget {
  const FuturePathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => ProgrammeProvider()),
      ],
      child: MaterialApp(
        title: 'FuturePath',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF111111),
          primaryColor: const Color(0xFFE03A2F),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFE03A2F),
            secondary: Color(0xFFE03A2F),
            surface: Color(0xFF111111),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF111111),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xFFF0EDE8),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/staff/dashboard': (context) => const StaffDashboardScreen(),
          '/staff/jobs': (context) => const StaffManageJobsScreen(),
          '/staff/jobs/add': (context) => const StaffManageJobsScreen(),
          '/staff/programmes': (context) => const StaffManageProgrammesScreen(),
          '/staff/programmes/add': (context) => const StaffManageProgrammesScreen(),
          '/staff/activity': (context) => const Placeholder(child: Text('Activity Screen')),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text(
                  'Page not found',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
