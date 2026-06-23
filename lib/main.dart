import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

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

      // Start app with Splash Screen
      initialRoute: AppRouter.splash,

      // Handle navigation through AppRouter
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}