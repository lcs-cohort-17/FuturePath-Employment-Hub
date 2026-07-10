import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../router/app_router.dart';
import '../../core/widgets/notification_badge.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/notifications_provider.dart';

// ---------------------------------------------------------------------------
// Mock model — replace with real AdminProfile from your data layer (AUTH-007)
// ---------------------------------------------------------------------------

class AdminProfileData {
  final String initials;
  final String fullName;
  final String title;
  final String organisation;
  final String email;
  final String role;
  final String department;
  final String memberSince;
  final int staffApproved;
  final int staffRejected;
  final String lastLogin;
  final int totalSessions;

  const AdminProfileData({
    required this.initials,
    required this.fullName,
    required this.title,
    required this.organisation,
    required this.email,
    required this.role,
    required this.department,
    required this.memberSince,
    required this.staffApproved,
    required this.staffRejected,
    required this.lastLogin,
    required this.totalSessions,
  });
}

// ---------------------------------------------------------------------------
// Mock service — swap fetchProfile() body for real Supabase call (AUTH-007)
// ---------------------------------------------------------------------------

class _AdminProfileService {
  Future<AdminProfileData> fetchProfile() async {
    // [AUTH-007] — Replace this with a real Supabase fetch for the
    // authenticated admin user. Return an AdminProfileData mapped from
    // the DB row.
    await Future.delayed(const Duration(milliseconds: 400));
    return const AdminProfileData(
      initials: 'KM',
      fullName: 'Kagiso Mokoena',
      title: 'Technical Lead',
      organisation: 'FuturePath',
      email: 'k.mokoena@futurepath.co.za',
      role: 'Admin',
      department: 'Engineering',
      memberSince: 'Jan 2026',
      staffApproved: 14,
      staffRejected: 3,
      lastLogin: 'Today',
      totalSessions: 247,
    );
  }

  Future<void> signOut() async {
    // [AUTH-007] — Replace with real Supabase Auth signOut() call and
    // clear any local session / provider state before navigating.
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

// ---------------------------------------------------------------------------
// Permission entry model
// ---------------------------------------------------------------------------

class _PermissionEntry {
  final String label;
  final bool allowed;

  const _PermissionEntry(this.label, {required this.allowed});
}

const List<_PermissionEntry> _kPermissions = [
  _PermissionEntry('System settings & health', allowed: true),
  _PermissionEntry('Staff management (approve/reject)', allowed: true),
  _PermissionEntry('Anonymized activity logs', allowed: true),
  _PermissionEntry('Content performance data', allowed: true),
  _PermissionEntry('User personal data', allowed: false),
  _PermissionEntry('CV or identity documents', allowed: false),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class AdminProfileScreen extends ConsumerStatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  ConsumerState<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends ConsumerState<AdminProfileScreen> {
  final _service = _AdminProfileService();

  late Future<AdminProfileData> _profileFuture;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _service.fetchProfile();
  }

  // -------------------------------------------------------------------------
  // Sign-out handler
  // -------------------------------------------------------------------------

  Future<void> _handleSignOut() async {
    setState(() => _signingOut = true);
    try {
      await _service.signOut();
      if (!mounted) return;
      
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.login,
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed out successfully'),
          backgroundColor: AppTheme.surface3,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign out failed. Please try again.'),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: _TopBar(),
      body: FutureBuilder<AdminProfileData>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Failed to load profile.',
                style: TextStyle(color: AppTheme.mutedText, fontSize: 13),
              ),
            );
          }
          return _ProfileBody(
            data: snapshot.data!,
            signingOut: _signingOut,
            onSignOut: _handleSignOut,
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top app bar — mirrors HTML topbar() helper
// ---------------------------------------------------------------------------

class _TopBar extends ConsumerWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Brand mark
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(7),
            ),
            alignment: Alignment.center,
            child: const Text(
              'FP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            'My Profile',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const NotificationBadge(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scrollable body — composed of discrete section widgets
// ---------------------------------------------------------------------------

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.data,
    required this.signingOut,
    required this.onSignOut,
  });

  final AdminProfileData data;
  final bool signingOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(data: data),
          const SizedBox(height: 4),
          _AccessBanner(),
          const SizedBox(height: 2),
          _InfoBlock(
            title: 'Account Details',
            child: _AccountDetailsGrid(data: data),
          ),
          _InfoBlock(
            title: 'Admin Activity',
            child: _AdminActivityGrid(data: data),
          ),
          _InfoBlock(
            title: 'Access Permissions',
            child: _PermissionsList(),
          ),
          _SignOutButton(loading: signingOut, onTap: onSignOut),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile header — avatar, name, title, role pill
// ---------------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.data});

  final AdminProfileData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A0A0A), Color(0xFF3D1010)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  data.initials,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Full name
              Text(
                data.fullName,
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              // Title · Organisation
              Text(
                '${data.title} · ${data.organisation}',
                style: const TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 7),
              // Admin role pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLow,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.shield_outlined,
                        color: AppTheme.primary, size: 10),
                    SizedBox(width: 5),
                    Text(
                      'Admin',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Full admin access banner
// ---------------------------------------------------------------------------

class _AccessBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.verified_user_outlined,
              color: AppTheme.primary, size: 16),
          SizedBox(width: 8),
          Text(
            'Full Admin Access',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Text(
            '· Provisioned via Supabase',
            style: TextStyle(color: AppTheme.mutedText, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable labelled info block card
// ---------------------------------------------------------------------------

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Account Details — 2-column grid
// ---------------------------------------------------------------------------

class _AccountDetailsGrid extends StatelessWidget {
  const _AccountDetailsGrid({required this.data});

  final AdminProfileData data;

  @override
  Widget build(BuildContext context) {
    final cells = [
      _GridCell(label: 'EMAIL', value: data.email, smallValue: true),
      _GridCell(label: 'ROLE', value: data.role, valueColor: AppTheme.primary, bold: true),
      _GridCell(label: 'DEPARTMENT', value: data.department),
      _GridCell(label: 'SINCE', value: data.memberSince),
    ];

    return _TwoColumnGrid(cells: cells);
  }
}

// ---------------------------------------------------------------------------
// Admin Activity — 2-column grid with large stat numbers
// ---------------------------------------------------------------------------

class _AdminActivityGrid extends StatelessWidget {
  const _AdminActivityGrid({required this.data});

  final AdminProfileData data;

  @override
  Widget build(BuildContext context) {
    final cells = [
      _GridCell(
        label: 'STAFF APPROVED',
        value: data.staffApproved.toString(),
        valueColor: AppTheme.success,
        largeStat: true,
      ),
      _GridCell(
        label: 'STAFF REJECTED',
        value: data.staffRejected.toString(),
        valueColor: AppTheme.primary,
        largeStat: true,
      ),
      _GridCell(label: 'LAST LOGIN', value: data.lastLogin),
      _GridCell(
          label: 'SESSIONS',
          value: '${data.totalSessions} total'),
    ];

    return _TwoColumnGrid(cells: cells);
  }
}

// ---------------------------------------------------------------------------
// Shared 2-column grid layout
// ---------------------------------------------------------------------------

class _GridCell {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  final bool largeStat;
  final bool smallValue;

  const _GridCell({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
    this.largeStat = false,
    this.smallValue = false,
  });
}

class _TwoColumnGrid extends StatelessWidget {
  const _TwoColumnGrid({required this.cells});

  final List<_GridCell> cells;

  @override
  Widget build(BuildContext context) {
    // Pair cells into rows of 2
    final rows = <List<_GridCell>>[];
    for (var i = 0; i < cells.length; i += 2) {
      rows.add([
        cells[i],
        if (i + 1 < cells.length) cells[i + 1],
      ]);
    }

    return Column(
      children: rows
          .map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: row
                    .map(
                      (cell) => Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cell.label,
                              style: const TextStyle(
                                color: AppTheme.subtleText,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cell.value,
                              style: TextStyle(
                                color: cell.valueColor ?? AppTheme.textDark,
                                fontSize: cell.largeStat
                                    ? 16
                                    : cell.smallValue
                                        ? 10
                                        : 11,
                                fontWeight: cell.largeStat || cell.bold
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Access Permissions list
// ---------------------------------------------------------------------------

class _PermissionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _kPermissions
          .map((p) => _PermissionRow(entry: p))
          .toList(),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.entry});

  final _PermissionEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = entry.allowed ? AppTheme.success : AppTheme.primary;
    final icon = entry.allowed ? Icons.check : Icons.close;
    final statusLabel = entry.allowed ? 'Allowed' : 'Blocked';

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.label,
              style: const TextStyle(
                color: AppTheme.mutedText,
                fontSize: 11,
              ),
            ),
          ),
          Row(
            children: [
              Icon(icon, color: color, size: 12),
              const SizedBox(width: 4),
              Text(
                statusLabel,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sign Out button
// ---------------------------------------------------------------------------

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.loading, required this.onTap});

  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 6, 14, 0),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppTheme.primary,
                ),
              )
            else
              const Icon(Icons.logout, color: AppTheme.primary, size: 16),
            const SizedBox(width: 7),
            Text(
              loading ? 'Signing out…' : 'Sign Out',
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

