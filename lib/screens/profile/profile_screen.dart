import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_profile_provider.dart';
import '../../services/auth_services.dart';
import '../../models/user_profile.dart';
import 'cv_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final authService = ref.watch(authServiceProvider);

    return ProfileScreenContent(
      userProfile: userProfile,
      onSignOut: () async {
        try {
          await authService.logout();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      onNavigateToCV: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CVScreen()),
        );
      },
    );
  }
}

/// Separated UI for easier testing
class ProfileScreenContent extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onSignOut;
  final VoidCallback onNavigateToCV;

  const ProfileScreenContent({
    super.key,
    required this.userProfile,
    required this.onSignOut,
    required this.onNavigateToCV,
  });

  @override
  State<ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<ProfileScreenContent> {
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(
          'My Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => _isEditMode = !_isEditMode),
            child: Text(
              _isEditMode ? 'Save' : 'Edit',
              style: TextStyle(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and Basic Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.primary.withAlpha(26),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.userProfile.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.userProfile.location,
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primary.withAlpha(51),
                      ),
                    ),
                    child: Text(
                      widget.userProfile.employmentStatus,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Conditional Hired Banner
            if (widget.userProfile.isHired) ...[
              const SizedBox(height: 24),
              _buildHiredBanner(),
            ],

            const SizedBox(height: 24),

            // Contact & Identity Section
            _buildSectionCard(
              title: 'Contact & Identity',
              children: [
                _buildInformationRow(
                  Icons.email_outlined,
                  'Email',
                  widget.userProfile.email,
                ),
                const Divider(height: 24),
                _buildInformationRow(
                  Icons.phone_outlined,
                  'Phone',
                  widget.userProfile.phone,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Bio Section
            _buildSectionCard(
              title: 'Bio',
              children: [
                Text(
                  widget.userProfile.bio ?? 'No bio provided.',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // CV / Resume Navigation
            _buildCVNavigationCard(),

            const SizedBox(height: 32),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.onSignOut,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHiredBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Text(
            "You're Hired!",
            style: TextStyle(
              color: Colors.green.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInformationRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.mutedText),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value ?? 'Not provided',
                style: TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCVNavigationCard() {
    return InkWell(
      onTap: widget.onNavigateToCV,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: AppTheme.accent,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CV / Resume',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'View and manage your skills',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.mutedText,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
