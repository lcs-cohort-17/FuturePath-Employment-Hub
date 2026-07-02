// TODO: Replace with final design (PO-UIUX-012)
// Placeholder for staff profile.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_services.dart';
import '../../providers/user_profile_provider.dart';

class StaffProfile extends ConsumerWidget {
  const StaffProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = AuthService();
    final user = auth.currentUser;
    final userProfile = ref.watch(userProfileProvider);

    final String displayName = userProfile.name.isEmpty 
        ? (user?.email?.split('@').first ?? 'Staff User')
        : userProfile.name;
    
    final String initial = userProfile.name.isEmpty
        ? (user?.email?.split('@').first.substring(0, 1).toUpperCase() ?? 'S')
        : userProfile.name.substring(0, 1).toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'Staff Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFFE03A2F),
              child: Text(
                initial,
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Staff Account',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Active',
              style: TextStyle(color: Colors.green, fontSize: 14),
            ),
            const SizedBox(height: 24),

            const Divider(color: Colors.white12),

            const SizedBox(height: 16),
            const Text(
              'Account Details',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Name', userProfile.name),
            _buildInfoRow('Email', user?.email ?? 'No email'),
            _buildInfoRow('Role', 'Staff'),

            const SizedBox(height: 24),
            const Divider(color: Colors.white12),

            const SizedBox(height: 16),
            const Text(
              'Privacy Notice',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'As a staff member you can view aggregated analytics only. '
                  'Applicant personal data (names, emails, IDs, CVs) is never accessible to your account.',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}