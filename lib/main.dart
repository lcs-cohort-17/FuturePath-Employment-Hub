import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'services/auth_services.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/programmes/programme_list_screen.dart';
import 'package:futurepath_employment_hub/screens/programmes/programme_detail_screen.dart';
import 'package:futurepath_employment_hub/screens/programmes/programme_application_screen.dart';

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
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.login, // Start with Login screen
      onGenerateRoute: AppRouter.generateRoute, // Use your router
    );
  }
}