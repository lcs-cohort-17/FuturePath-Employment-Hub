import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../services/auth_services.dart';
import '../../services/staff_content_service.dart';

class StaffEnrolments extends StatefulWidget {
  const StaffEnrolments({super.key});

  @override
  State<StaffEnrolments> createState() => _StaffEnrolmentsState();
}

class _StaffEnrolmentsState extends State<StaffEnrolments> {
  late Future<List<Map<String, dynamic>>> _enrolmentsFuture;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadEnrolments();
  }

  void _loadEnrolments() {
    final userId = _auth.currentUser?.id;
    if (userId != null) {
      setState(() {
        _enrolmentsFuture = StaffContentService.getStaffEnrolments(userId);
      });
    }
  }

  Future<void> _updateStatus(String enrolmentId, String newStatus) async {
    try {
      await StaffContentService.updateEnrolmentStatus(enrolmentId, newStatus);
      _loadEnrolments();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enrolment status updated'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteEnrolment(String enrolmentId, String status) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2E30),
        title: const Text('Delete Enrolment', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this enrolment? Status is "$status".',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await StaffContentService.deleteEnrolment(enrolmentId);
        _loadEnrolments();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enrolment deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting enrolment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'Programme Enrolments',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadEnrolments,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _enrolmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final enrolments = snapshot.data ?? [];
          if (enrolments.isEmpty) {
            return const Center(
              child: Text(
                'No programme enrolments yet.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: enrolments.length,
            itemBuilder: (context, index) {
              final enrolment = enrolments[index];
              final programme = enrolment['Training Programme'] as Map<String, dynamic>?;
              final applicantId = enrolment['Applicant_id'] ?? 'N/A';
              final status = enrolment['Enrolment_Status'] ?? 'pending';
              final programmeName = programme?['Programme_Name'] ?? 'Unknown Programme';
              final level = programme?['level'] ?? '';
              final duration = programme?['duration_months'] ?? 0;
              final enrolled = programme?['enrolled_count'] ?? 0;
              final capacity = programme?['Capacity'] ?? 0;
              final enrolmentId = enrolment['Enrolment_id'] ?? '';

              final statusColor = status == 'completed'
                  ? AppTheme.success
                  : status == 'enrolled'
                  ? AppTheme.info
                  : AppTheme.warning;

              return Card(
                color: const Color(0xFF2C2E30),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Applicant ID + Delete button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person_outline, color: Colors.white54, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Applicant: #$applicantId',
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _deleteEnrolment(enrolmentId, status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        programmeName,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Level: $level · ${duration} months',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 14,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$enrolled / $capacity enrolled',
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Status dropdown
                      Row(
                        children: [
                          const Text(
                            'Status:',
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButton<String>(
                              value: status,
                              dropdownColor: const Color(0xFF2C2E30),
                              style: const TextStyle(color: Colors.white),
                              isExpanded: true,
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  _updateStatus(enrolmentId, newStatus);
                                }
                              },
                              items: ['pending', 'enrolled', 'completed', 'rejected']
                                  .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.toUpperCase()),
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      if (status == 'completed' && enrolment['Completion_Date'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Completed: ${_formatDate(DateTime.parse(enrolment['Completion_Date']))}',
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}