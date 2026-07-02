// lib/screens/staff/staff_applications.dart
// Staff view applications with CV + motivational letter download + delete

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/auth_services.dart';
import '../../services/staff_application_service.dart';

class StaffApplications extends StatefulWidget {
  const StaffApplications({super.key});

  @override
  State<StaffApplications> createState() => _StaffApplicationsState();
}

class _StaffApplicationsState extends State<StaffApplications> {
  late Future<List<Map<String, dynamic>>> _applicationsFuture;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    final userId = _auth.currentUser?.id;
    if (userId != null) {
      setState(() {
        _applicationsFuture = StaffApplicationService.getStaffApplications(userId);
      });
    }
  }

  Future<void> _updateStatus(String applicationId, String status) async {
    await StaffApplicationService.updateApplicationStatus(applicationId, status);
    _loadApplications();
  }

  Future<void> _deleteApplication(String applicationId, String status) async {
    final statusLabel = status.replaceAll('_', ' ').toUpperCase();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2E30),
        title: const Text('Delete Application', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete this application? Status is currently "$statusLabel". This action cannot be undone.',
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
        await StaffApplicationService.deleteApplication(applicationId);
        _loadApplications();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting application: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _openFile(String url, String label) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $label'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'Applications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadApplications,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _applicationsFuture,
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
          final applications = snapshot.data ?? [];
          if (applications.isEmpty) {
            return const Center(
              child: Text(
                'No applications yet.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              final applicantId = app['Applicant']?['id'] ?? 'N/A';
              final qualification = app['Applicant']?['Highest_Qualification'] ?? 'Not specified';
              final cvUrl = app['cv_url'];
              final motivationalLetterUrl = app['motivational_letter_url'];
              final consentGiven = app['consent_given'] ?? false;
              final status = app['Application_Status'] ?? 'pending';
              final jobData = app['Employment Opportunity'];
              final jobTitle = jobData?['Position_Title'] ?? 'No title';
              final appliedDate = app['Application_Date'] != null
                  ? DateTime.parse(app['Application_Date'])
                  : DateTime.now();
              final applicationId = app['Job_Application_id'] ?? '';

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
                      // Header: Applicant ID + Delete button (always visible)
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
                          // ✅ Delete button – always visible (no status restriction)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _deleteApplication(applicationId, status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jobTitle,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 8),

                      // Qualification
                      Row(
                        children: [
                          const Icon(Icons.school_outlined, color: Colors.white54, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            qualification,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // CV link
                      if (cvUrl != null && cvUrl.isNotEmpty && consentGiven)
                        Row(
                          children: [
                            const Icon(Icons.description_outlined, color: Colors.white54, size: 16),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _openFile(cvUrl, 'CV'),
                              child: Text(
                                'View CV',
                                style: TextStyle(
                                  color: const Color(0xFFE03A2F),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        )
                      else if (cvUrl != null && cvUrl.isNotEmpty && !consentGiven)
                        Row(
                          children: [
                            const Icon(Icons.lock_outline, color: Colors.white38, size: 16),
                            const SizedBox(width: 8),
                            const Text(
                              'CV not shared (consent not given)',
                              style: TextStyle(color: Colors.white38, fontSize: 12),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'No CV attached',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),

                      // ─── Motivational Letter link ──────────────────────
                      if (motivationalLetterUrl != null && motivationalLetterUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.article_outlined, color: Colors.white54, size: 16),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _openFile(motivationalLetterUrl, 'Motivational Letter'),
                                child: Text(
                                  'View Motivational Letter',
                                  style: TextStyle(
                                    color: const Color(0xFFE03A2F),
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                  _updateStatus(applicationId, newStatus);
                                }
                              },
                              items: ['pending', 'under_review', 'accepted', 'rejected']
                                  .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.replaceAll('_', ' ').toUpperCase()),
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Applied: ${_formatDate(appliedDate)}',
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),

                      if (consentGiven)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Consent given',
                            style: TextStyle(color: Colors.green, fontSize: 10),
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