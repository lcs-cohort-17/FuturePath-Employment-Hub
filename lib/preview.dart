import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/admin/admin_job_applications_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const AdminJobApplicationsScreen(
      jobId: 'job-123',
      jobTitle: 'Junior Flutter Developer',
    ),
  ));
}
