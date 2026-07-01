// TODO: Replace with final design (PO-UIUX-027)
// ⚠️ This screen displays ONLY anonymized data:
// - Applicant ID (APP-001)
// - Qualification (Matric, Diploma, etc.)
// - CV download link (with consent)
// No names, emails, phone numbers, or addresses appear anywhere.

import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import '../../services/staff_application_service.dart';
import '../../models/staff_application_model.dart';

class StaffApplications extends StatefulWidget {
  const StaffApplications({super.key});

  @override
  State<StaffApplications> createState() => _StaffApplicationsState();
}

class _StaffApplicationsState extends State<StaffApplications> {
  late Future<List<StaffApplicationModel>> _applicationsFuture;
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
        // ✅ FIXED: Call static method directly on the class
        _applicationsFuture = StaffApplicationService.getStaffApplications(userId);
      });
    }
  }

  Future<void> _updateStatus(String applicationId, String status) async {
    // ✅ FIXED: Call static method directly on the class
    await StaffApplicationService.updateApplicationStatus(applicationId, status);
    _loadApplications();
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
      body: FutureBuilder<List<StaffApplicationModel>>(
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
              return Card(
                color: const Color(0xFF2C2E30),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Applicant ID (anonymized) — no name
                      Row(
                        children: [
                          const Icon(Icons.person_outline, color: Colors.white54, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Applicant: ${app.applicantId}',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Job Title
                      Row(
                        children: [
                          const Icon(Icons.work_outline, color: Colors.white54, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            app.jobTitle ?? 'No job',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Qualification (not PII)
                      Row(
                        children: [
                          const Icon(Icons.school, color: Colors.white54, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            app.applicantQualification ?? 'No qualification',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // CV download (CV itself may contain personal info, but it's part of the application with consent)
                      if (app.cvUrl != null && app.cvUrl!.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.description_outlined, color: Colors.white54, size: 16),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                // TODO: Open CV URL in browser or download
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('CV download: ${app.cvUrl}'),
                                  ),
                                );
                              },
                              child: Text(
                                'View CV',
                                style: TextStyle(color: const Color(0xFFE03A2F), fontSize: 14),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 16),

                      // Status Dropdown
                      Row(
                        children: [
                          const Text(
                            'Status:',
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButton<String>(
                              value: app.status,
                              dropdownColor: const Color(0xFF2C2E30),
                              style: const TextStyle(color: Colors.white),
                              isExpanded: true,
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  _updateStatus(app.id, newStatus);
                                }
                              },
                              items: ['pending', 'under_review', 'accepted', 'rejected']
                                  .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status.replaceAll('_', ' ').toUpperCase()),
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Applied Date
                      Text(
                        'Applied: ${_formatDate(app.appliedAt)}',
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
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