import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/notification_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: NotificationBadge(),
          ),
        ],
      ),
      body: const Center(
        child: Text('Profile Screen - Coming Soon'),
      ),
    );
  }
}
