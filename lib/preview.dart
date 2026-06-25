import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/admin/admin_applicants_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const AdminApplicantsScreen(),
  ));
}
