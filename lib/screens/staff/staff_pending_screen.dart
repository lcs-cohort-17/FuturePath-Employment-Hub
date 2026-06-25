import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../auth/login_screen.dart';
// import '../dashboard/staff_dashboard_screen.dart';

class StaffPendingScreen extends StatefulWidget {
  final Map<String, dynamic> submissionData;

  const StaffPendingScreen({super.key, required this.submissionData});

  @override
  State<StaffPendingScreen> createState() => _StaffPendingScreenState();
}

class _StaffPendingScreenState extends State<StaffPendingScreen> {
  // StreamSubscription? _statusSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToApprovalStatus();
  }

  void _subscribeToApprovalStatus() {
    // Example using Supabase realtime — adjust table/column names
    // to match your actual INT-010 schema.
    //
    // final email = widget.submissionData['workEmail'];
    // _statusSubscription = Supabase.instance.client
    //     .from('staff_accounts')
    //     .stream(primaryKey: ['id'])
    //     .eq('work_email', email)
    //     .listen((rows) {
    //   if (rows.isEmpty) return;
    //   final status = rows.first['status'];
    //   if (status == 'active') _onApproved();
    //   if (status == 'suspended') _onSuspended();
    // });
  }

  void _onApproved() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your account has been approved!'),
        backgroundColor: AppColors.green,
      ),
    );
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const StaffDashboardScreen()),
    // );
  }

  void _onSuspended() {
    if (!mounted) return;
    // Navigate to staff_suspended_screen.dart once built
  }

  @override
  void dispose() {
    // _statusSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.submissionData;
    final timestamp = data['timestamp'] as DateTime?;
    final formattedTimestamp = timestamp != null
        ? DateFormat('MMM d, yyyy • HH:mm').format(timestamp)
        : '';
    final fullName =
    '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
    final companyName = data['companyName'] ?? '';
    final email = data['workEmail'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.surf,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // pi-circle: clock icon in amber circle
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.amberLow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.amber,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),

                // plogtitle
                const Text(
                  'Account Pending Approval',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.t1,
                  ),
                ),
                const SizedBox(height: 10),

                // plogsubt
                const Text(
                  'Your business account has been submitted and is awaiting '
                      'admin verification.\n\nYou\'ll be notified once approved. '
                      'This typically takes 1–2 business days.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.t2,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Submission details card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surf2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.bdr),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SUBMISSION DETAILS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.t2,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$fullName · $companyName',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.t1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.t2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Submitted: $formattedTimestamp',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.t3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Green info box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.greenLow,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.green.withOpacity(0.2)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 14, color: AppColors.green),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'You can close the app and return once notified.',
                          style: TextStyle(fontSize: 10, color: AppColors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                SecondaryButton(
                  label: 'Back to Login',
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    // Or navigate explicitly:
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => const LoginScreen()),
                    //   (route) => false,
                    // );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
