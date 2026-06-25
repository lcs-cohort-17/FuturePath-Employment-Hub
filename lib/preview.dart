import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/admin/admin_enrolments_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const AdminEnrolmentsScreen(
      programmeId: 'PROG-001',
      programmeName: 'Flutter Mobile Development',
    ),
  ));
}
