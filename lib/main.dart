import 'package:flutter/material.dart';

// Project imports based on your workspace folder structure
import 'package:futurepath_employment_hub/screens/jobs/opportunity_list_screen.dart';
import 'package:futurepath_employment_hub/screens/jobs/track_applications_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuturePath Employment Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Fixed syntax bug from boilerplate template
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set the default initial path
      initialRoute: '/',
      // The application's named routing table
      routes: {
        // The root path loads up your jobs list dashboard
        '/': (context) => const OpportunityListScreen(),

        // Technical Requirement: Used by Navigator.pushNamed on the success screen
        '/track-applications': (context) => const TrackApplicationsScreen(),
      },
      // Optional: Fallback routing logic for dynamic page arguments if needed later
      onGenerateRoute: (settings) {
        // If you migrate other screens to named routes, they can be configured here.
        return null;
      },
    );
  }
}