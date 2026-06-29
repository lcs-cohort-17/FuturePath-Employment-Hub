import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class StaffProfileScreen extends StatefulWidget {
  const StaffProfileScreen({super.key});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  bool _isLoading = true;
  bool _isSigningOut = false;
  String? _errorMessage;

  String _fullName = '';
  String _jobTitle = '';
  String _companyName = '';
  String _email = '';
  String _role = '';
  String _status = '';
  String _approvalLabel = '';
  String _dateJoined = '';
  String _lastLogin = '';
  int _jobsPosted = 0;
  int _programmesListed = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {

      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _fullName = 'Bungcwalisa Magobiyane';
        _jobTitle = 'Staff Coordinator';
        _companyName = 'FuturePath Employment Hub';
        _email = 'bungcwalisa@example.com';
        _role = 'Staff';
        _status = 'active';
        _approvalLabel = 'Approved by Admin';
        _dateJoined = '12 Mar 2026';
        _lastLogin = 'Today, 08:42';
        _jobsPosted = 8;
        _programmesListed = 4;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile. Pull down to retry.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    if (_isSigningOut) return;

    setState(() => _isSigningOut = true);

    try {
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign out. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'ST';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  bool get _isActive => _status.toLowerCase() == 'active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surf,
      body: SafeArea(
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(color: AppColors.brand),
        )
            : _errorMessage != null
            ? _buildErrorState()
            : RefreshIndicator(
          onRefresh: _loadProfile,
          color: AppColors.brand,
          backgroundColor: AppColors.surf2,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopbar(),
                _buildProfileHeaderCard(),
                _buildSectionHeader('Account Details'),
                _buildAccountDetailsCard(),
                _buildSectionHeader('Activity Summary'),
                _buildActivitySummaryCard(),
                _buildSectionHeader('Privacy Notice'),
                _buildPrivacyNoticeCard(),
                _buildSignOutButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.t2,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.cardSm),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopbar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.surf,
        border: Border(
          bottom: BorderSide(color: AppColors.bdr, width: 0.5),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.person_outline,
            color: AppColors.t1,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'My Profile',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.t1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
    final initials = _initialsFromName(_fullName);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surf2,
        border: Border.all(color: AppColors.bdr, width: 0.5),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.blueLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.t1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _jobTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.t2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.blueLow,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _companyName,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                        _buildStatusChip(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surf,
              border: Border.all(color: AppColors.bdr, width: 0.5),
              borderRadius: BorderRadius.circular(AppRadii.cardSm),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 16,
                  color: _isActive ? AppColors.green : AppColors.t3,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _approvalLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.t2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    final Color bg = _isActive
        ? AppColors.green.withOpacity(0.12)
        : AppColors.amber.withOpacity(0.12);

    final Color fg = _isActive ? AppColors.green : AppColors.amber;
    final String label = _isActive ? 'Active' : _status;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.brand,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.t1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surf2,
        border: Border.all(color: AppColors.bdr, width: 0.5),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        children: [
          _buildDetailRow('Email', _email),
          _buildDivider(),
          _buildDetailRow('Role', _role),
          _buildDivider(),
          _buildDetailRow('Company', _companyName),
          _buildDivider(),
          _buildDetailRow('Date Joined', _dateJoined),
        ],
      ),
    );
  }

  Widget _buildActivitySummaryCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surf2,
        border: Border.all(color: AppColors.bdr, width: 0.5),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        children: [
          _buildDetailRow('Jobs Posted', '$_jobsPosted'),
          _buildDivider(),
          _buildDetailRow('Programmes Listed', '$_programmesListed'),
          _buildDivider(),
          _buildDetailRow('Last Login', _lastLogin),
          _buildDivider(),
          _buildDetailRow('Status', _isActive ? 'Active' : _status),
        ],
      ),
    );
  }

  Widget _buildPrivacyNoticeCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surf2,
        border: Border.all(color: AppColors.bdr, width: 0.5),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline,
            size: 16,
            color: AppColors.t3,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your profile details are visible only to authorised administrators and used to manage your staff account. Applicant personal data is never shown on this profile screen.',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.t3,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isSigningOut ? null : _signOut,
          icon: _isSigningOut
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Icon(Icons.logout, size: 18),
          label: Text(_isSigningOut ? 'Signing out...' : 'Sign Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brand,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.cardSm),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.t2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.t1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.bdr,
    );
  }
}