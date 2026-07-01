import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/jobs/employer_detail_screen.dart';
import 'models/employer.dart';

void main() {
  final mockEmployer = EmployerModel(
    id: '1',
    companyName: 'TechNova Solutions',
    industry: 'Technology',
    location: 'Cape Town, South Africa',
    website: 'https://technova.co.za',
    email: 'careers@technova.co.za',
    bio: 'TechNova Solutions is a leading technology company specializing in innovative software solutions. We build cross-platform mobile apps using Flutter & Dart for iOS and Android.',
    activeOpeningsCount: 5,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: EmployerDetailScreen(
      employerData: mockEmployer,
    ),
  ));
}
