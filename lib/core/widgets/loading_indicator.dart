import 'package:flutter/material.dart';
//import 'package:futurepath/theme.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator({super.key, this.color = AppTheme.primary});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: 2.5,
      ),
    );
  }
}