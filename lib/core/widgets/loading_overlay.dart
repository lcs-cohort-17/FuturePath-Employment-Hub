import 'package:flutter/material.dart';
//import 'package:futurepath/theme.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surface.withOpacity(0.72),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
        ),
      ),
    );
  }
}