import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../services/auth_services.dart';
import '../../services/public_data_service.dart';

class MyProgrammesScreen extends StatefulWidget {
  const MyProgrammesScreen({super.key});

  @override
  State<MyProgrammesScreen> createState() => _MyProgrammesScreenState();
}

class _MyProgrammesScreenState extends State<MyProgrammesScreen> {
  List<Map<String, dynamic>> _enrolments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEnrolments();
  }

  Future<void> _loadEnrolments() async {
    setState(() => _loading = true);
    try {
      final user = AuthService().currentUser;
      if (user == null) throw Exception('Not logged in');

      final supabase = Supabase.instance.client;
      final profile = await supabase
          .from('Applicant')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      final applicantId = profile?['id'] as int?;
      if (applicantId == null) throw Exception('Applicant profile not found');

      final data = await PublicDataService.getMyProgrammeEnrolments(applicantId);
      setState(() {
        _enrolments = data;
        _loading = false;
      });
    } catch (e) {
      print('❌ Error loading programme enrolments: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Programmes',
          style: TextStyle(
            color: AppTheme.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: AppTheme.border, height: 0.5),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : _enrolments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _enrolments.length,
        itemBuilder: (context, index) {
          final enrolment = _enrolments[index];
          final programme = enrolment['Training Programme'] as Map<String, dynamic>?;
          final status = enrolment['Enrolment_Status'] ?? 'pending';
          final programmeName = programme?['Programme_Name'] ?? 'Unknown Programme';
          final level = programme?['level'] ?? '';
          final duration = programme?['duration_months'] ?? 0;
          final enrolled = programme?['enrolled_count'] ?? 0;
          final capacity = programme?['Capacity'] ?? 0;

          final statusColor = status == 'completed'
              ? AppTheme.success
              : status == 'enrolled'
              ? AppTheme.info
              : AppTheme.warning;

          final statusLabel = status.toUpperCase();

          return Card(
            color: AppTheme.surface2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: AppTheme.border, width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          programmeName,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level: $level · ${duration} months',
                    style: const TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 14,
                        color: AppTheme.subtleText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$enrolled / $capacity enrolled',
                        style: const TextStyle(
                          color: AppTheme.subtleText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 48,
            color: AppTheme.subtleText,
          ),
          const SizedBox(height: 16),
          const Text(
            'No programme enrolments yet.',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apply to a programme to get started.',
            style: TextStyle(
              color: AppTheme.subtleText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}