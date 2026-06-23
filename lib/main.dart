import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

void main() {
  runApp(const FuturePathApp());
}

class FuturePathApp extends StatelessWidget {
  const FuturePathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuturePath Employment Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}