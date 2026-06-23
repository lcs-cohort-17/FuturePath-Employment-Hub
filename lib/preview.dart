import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/jobs/job_list_screen.dart'; // Import the screen

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const OpportunityListScreen(), // Set it as the home screen
  ));
}