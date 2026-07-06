import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_profile_provider.dart';
import '../../services/auth_services.dart';
import '../../models/user_profile.dart';
import '../../router/app_router.dart';
import 'cv_screen.dart';
import 'edit_profile_screen.dart';
import '../../core/errors/delete_account_error.dart';
import '../../core/widgets/delete_account_dialog.dart';
import '../../core/widgets/delete_account_error_sheet.dart';
import '../../services/job_application_service.dart';
import '../../providers/notifications_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../programmes/my_programmes_screen.dart';// ✅ NEW IMPORT
import '../../core/widgets/notification_badge.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List<Map<String, dynamic>> _applications = [];
  bool _loadingApplications = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _loadingApplications = true);
    try {
      final user = AuthService().currentUser;
      if (user != null) {
        final supabase = Supabase.instance.client;
        final profile = await supabase
            .from('Applicant')
            .select('id')
            .eq('user_id', user.id)
            .maybeSingle();
        final applicantId = profile?['id'] as int?;
        if (applicantId != null) {
          final apps = await JobApplicationService.getApplicationsForApplicant(applicantId);
          setState(() {
            _applications = apps;
            _loadingApplications = false;
          });
          return;
        }
      }
      setState(() => _loadingApplications = false);
    } catch (e) {
      print('❌ Error loading applications: $e');
      setState(() => _loadingApplications = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final authService = ref.watch(authServiceProvider);

    return ProfileScreenContent(
      userProfile: userProfile,
      ref: ref,
      onSignOut: () async {
        try {
          await authService.logout();
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, AppRouter.login);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: $e'),
                backgroundColor: AppTheme.error,
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
      applications: _applications,
      loadingApplications: _loadingApplications,
      onRefresh: _loadApplications,
    );
  }
}

class ProfileScreenContent extends StatefulWidget {
  final UserProfile userProfile;
  final VoidCallback onSignOut;
  final VoidCallback onNavigateToCV;
  final WidgetRef ref;
  final List<Map<String, dynamic>> applications;
  final bool loadingApplications;
  final VoidCallback onRefresh;

  const ProfileScreenContent({
    super.key,
    required this.userProfile,
    required this.onSignOut,
    required this.onNavigateToCV,
    required this.ref,
    required this.applications,
    required this.loadingApplications,
    required this.onRefresh,
  });

  @override
  State<ProfileScreenContent> createState() => _ProfileScreenContentState();
}

class _ProfileScreenContentState extends State<ProfileScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => widget.onRefresh(),
          color: AppTheme.primary,
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(),
                      _buildHiredBanner(),
                      _buildContactIdentityBlock(),
                      _buildSkillsBlock(),
                      _buildApplicationsBlock(),
                      _buildProgrammesSummary(), // ✅ NEW CARD
                      _buildSignOutButton(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── All existing methods (unchanged) ──────────────────────────────────

  Widget _buildTopBar() {
    final notifications = widget.ref.watch(notificationsProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Center(
                  child: Text(
                    'FP',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'FuturePath',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
          const NotificationBadge(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDim,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(widget.userProfile.name),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.userProfile.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 11, color: AppTheme.mutedText),
                      const SizedBox(width: 4),
                      Text(
                        widget.userProfile.location.isNotEmpty ? widget.userProfile.location : 'Location not set',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.border, width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.userProfile.employmentStatus,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(profile: widget.userProfile),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.surface2,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: AppTheme.border, width: 0.5),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.edit_outlined, size: 12, color: AppTheme.primary),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHiredBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppTheme.successLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.success.withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.celebration_outlined, size: 18, color: AppTheme.success),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "YOU'RE HIRED!",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.success,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Salesforce Admin Intern · FutureTech Africa',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'R12,000/month + allowances',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactIdentityBlock() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONTACT & IDENTITY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.mutedText,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildInfoCell('EMAIL', widget.userProfile.email),
              ),
              Expanded(
                child: _buildInfoCell('PHONE', widget.userProfile.phone?.isNotEmpty == true ? widget.userProfile.phone! : 'Not provided'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoCell('ID NUMBER', widget.userProfile.idNumber?.isNotEmpty == true ? _maskId(widget.userProfile.idNumber!) : 'Not provided'),
              ),
              Expanded(
                child: _buildInfoCell(
                  'QUALIFICATION',
                  widget.userProfile.education?.isNotEmpty == true
                      ? widget.userProfile.education!
                      : 'Not provided',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _maskId(String id) {
    if (id.length < 10) return id;
    return '${id.substring(0, 6)}•••••${id.substring(id.length - 3)}';
  }

  Widget _buildInfoCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppTheme.subtleText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsBlock() {
    final skills = widget.userProfile.skills.isNotEmpty
        ? widget.userProfile.skills
        : ['Microsoft Office', 'Communication', 'Problem Solving'];

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SKILLS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.mutedText,
                  letterSpacing: 0.4,
                ),
              ),
              GestureDetector(
                onTap: widget.onNavigateToCV,
                child: Row(
                  children: const [
                    Icon(Icons.add, size: 12, color: AppTheme.primary),
                    SizedBox(width: 3),
                    Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryLow,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 10,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  // ─── Active Job Applications ─────────────────────────────────────────────

  Widget _buildApplicationsBlock() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACTIVE APPLICATIONS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.mutedText,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          if (widget.loadingApplications)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            )
          else if (widget.applications.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No applications yet.',
                style: TextStyle(color: AppTheme.mutedText, fontSize: 11),
              ),
            )
          else
            ...widget.applications.map((app) {
              final status = app['Application_Status'] ?? 'pending';
              final jobTitle = app['Employment Opportunity']?['Position_Title'] ?? 'Unknown job';
              final statusColor = _getStatusColor(status);
              final progress = _getProgress(status);
              final icon = _getIcon(status);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildApplicationRow(
                  iconBg: statusColor.withOpacity(0.12),
                  icon: icon,
                  iconColor: statusColor,
                  title: jobTitle,
                  badgeLabel: status.replaceAll('_', ' ').toUpperCase(),
                  badgeColor: statusColor,
                  badgeBg: statusColor.withOpacity(0.12),
                  progress: progress,
                  progressColor: statusColor,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'accepted':
        return AppTheme.success;
      case 'under_review':
        return AppTheme.warning;
      case 'rejected':
        return AppTheme.error;
      default:
        return AppTheme.info;
    }
  }

  double _getProgress(String status) {
    switch (status) {
      case 'accepted':
        return 1.0;
      case 'under_review':
        return 0.6;
      case 'pending':
        return 0.3;
      case 'rejected':
        return 0.0;
      default:
        return 0.3;
    }
  }

  IconData _getIcon(String status) {
    switch (status) {
      case 'accepted':
        return Icons.check_rounded;
      case 'under_review':
        return Icons.access_time_rounded;
      case 'rejected':
        return Icons.close_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  Widget _buildApplicationRow({
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String badgeLabel,
    required Color badgeColor,
    required Color badgeBg,
    required double progress,
    required Color progressColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: iconColor, size: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      badgeLabel,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: AppTheme.surface3,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── NEW: My Programmes card ─────────────────────────────────────────────

  Widget _buildProgrammesSummary() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MyProgrammesScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.school_outlined, color: AppTheme.primary, size: 20),
                const SizedBox(width: 10),
                const Text(
                  'My Programmes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: AppTheme.mutedText, size: 14),
          ],
        ),
      ),
    );
  }

  // ─── Sign Out & Delete ─────────────────────────────────────────────────

  Widget _buildSignOutButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onSignOut,
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 6, 14, 10),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.logout, size: 14, color: AppTheme.primary),
                SizedBox(width: 7),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _handleDeleteAccount(widget.ref),
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.errorLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppTheme.error.withOpacity(0.2), width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.delete_forever_rounded,
                    size: 16, color: AppTheme.error),
                SizedBox(width: 7),
                Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.shield_outlined, size: 12, color: AppTheme.subtleText),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Deleting your account permanently removes all personal data in accordance with POPIA.',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppTheme.subtleText,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleDeleteAccount(WidgetRef ref) async {
    final confirmed = await showDeleteAccountDialog(context);
    if (!confirmed || !mounted) return;

    final String? userId = widget.userProfile.userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User ID not found.')),
      );
      return;
    }

    final notifier = ref.read(userProfileProvider.notifier);
    final success = await notifier.deleteAccount(userId);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
            (_) => false,
        arguments: 'Account deleted successfully.',
      );
    } else {
      final error = notifier.deleteAccountError;
      if (error != null) {
        await showDeleteAccountErrorSheet(
          context: context,
          error: error,
          onRetry: () => _handleDeleteAccount(ref),
        );
        if (mounted) notifier.clearDeleteAccountError();
      }
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}