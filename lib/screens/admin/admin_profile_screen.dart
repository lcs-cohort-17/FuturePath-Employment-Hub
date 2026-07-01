import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../core/widgets/loading_widget.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Loading profile...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A0A0A), Color(0xFF3D1010)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'KM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kagiso Mokoena',
                              style: TextStyle(
                                color: Color(0xFFF0EDE8),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'Technical Lead · FuturePath',
                              style: TextStyle(
                                color: Color(0xFF9E9B96),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE03A2F).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE03A2F).withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.shield,
                                    color: Color(0xFFE03A2F),
                                    size: 10,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Admin',
                                    style: TextStyle(
                                      color: Color(0xFFE03A2F),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Full Admin Access Banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE03A2F).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE03A2F).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield,
                        color: Color(0xFFE03A2F),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Full Admin Access',
                        style: TextStyle(
                          color: Color(0xFFE03A2F),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '· Provisioned via Supabase',
                        style: TextStyle(
                          color: Color(0xFF9E9B96),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Account Details
                _InfoBlock(
                  title: 'ACCOUNT DETAILS',
                  children: [
                    _InfoRow(label: 'EMAIL', value: 'k.mokoena@futurepath.co.za'),
                    _InfoRow(label: 'ROLE', value: 'Admin', valueColor: const Color(0xFFE03A2F)),
                    _InfoRow(label: 'DEPARTMENT', value: 'Engineering'),
                    _InfoRow(label: 'SINCE', value: 'Jan 2026'),
                  ],
                ),

                // Admin Activity
                _InfoBlock(
                  title: 'ADMIN ACTIVITY',
                  children: [
                    _InfoRow(label: 'STAFF APPROVED', value: '14', valueColor: const Color(0xFF2ECC8A)),
                    _InfoRow(label: 'STAFF REJECTED', value: '3', valueColor: const Color(0xFFE03A2F)),
                    _InfoRow(label: 'LAST LOGIN', value: 'Today'),
                    _InfoRow(label: 'SESSIONS', value: '247 total'),
                  ],
                ),

                // Access Permissions
                _InfoBlock(
                  title: 'ACCESS PERMISSIONS',
                  children: [
                    _PermissionRow(label: 'System settings & health', allowed: true),
                    _PermissionRow(label: 'Staff management (approve/reject)', allowed: true),
                    _PermissionRow(label: 'Anonymized activity logs', allowed: true),
                    _PermissionRow(label: 'Content performance data', allowed: true),
                    _PermissionRow(label: 'User personal data', allowed: false),
                    _PermissionRow(label: 'CV or identity documents', allowed: false),
                  ],
                ),

                // Sign Out Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showSignOutDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Color(0xFFE03A2F),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.logout, color: Color(0xFFE03A2F), size: 16),
                          SizedBox(width: 7),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Color(0xFFE03A2F),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Color(0xFFF0EDE8), fontSize: 16),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Color(0xFF9E9B96), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9E9B96))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFE03A2F)),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoBlock({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9E9B96),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF5C5A57),
              fontSize: 9,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? const Color(0xFFF0EDE8),
              fontSize: 11,
              fontWeight: valueColor != null ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  final String label;
  final bool allowed;

  const _PermissionRow({
    required this.label,
    required this.allowed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9E9B96),
              fontSize: 11,
            ),
          ),
          Row(
            children: [
              Icon(
                allowed ? Icons.check_circle : Icons.cancel,
                color: allowed ? const Color(0xFF2ECC8A) : const Color(0xFFE03A2F),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                allowed ? 'Allowed' : 'Blocked',
                style: TextStyle(
                  color: allowed ? const Color(0xFF2ECC8A) : const Color(0xFFE03A2F),
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