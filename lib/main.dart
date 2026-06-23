import 'package:flutter/material.dart';
import '../screens/jobs/opportunity_detail_screen.dart';
import '../screens/profile/track_applications_screen.dart';

void main() {
  runApp(const FuturePathApp());
}

class FuturePathApp extends StatelessWidget {
  const FuturePathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FuturePath Employment Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // Set the initial route to launch the Job Details Screen
      initialRoute: '/',
      routes: {
        '/': (context) => const OpportunityDetailScreen(),
        // Subtask 4: Named route configured for Track Applications
        '/trackApplications': (context) => const TrackApplicationsScreen(),
      },
    );
  }
}