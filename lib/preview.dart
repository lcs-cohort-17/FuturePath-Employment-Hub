import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/screens/admin/admin_employers_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const AdminEmployersScreen(), // Set it as the home screen
  ));
}