import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/screens/staff/staff_registration_screen.dart';

void main() {
  runApp(const StaffApp());
}

class StaffApp extends StatelessWidget {
  const StaffApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuturePath Staff',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const StaffRegistrationScreen(),
    );
  }
}