// TODO: Replace with final design (PO-UIUX-009)
// ✅ Uses StaffJobModel with correct column names

import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import '../../services/staff_content_service.dart';
import '../../models/staff_job_model.dart';
import '../../router/app_router.dart';

class StaffManageJobs extends StatefulWidget {
  const StaffManageJobs({super.key});

  @override
  State<StaffManageJobs> createState() => _StaffManageJobsState();
}

class _StaffManageJobsState extends State<StaffManageJobs> {
  late Future<List<StaffJobModel>> _jobsFuture;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() {
    final userId = _auth.currentUser?.id;
    if (userId != null) {
      setState(() {
        _jobsFuture = StaffContentService.getMyJobs(userId);
      });
    }
  }

  Future<void> _deleteJob(String opportunityId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content: const Text('Are you sure you want to delete this job?'),
        backgroundColor: const Color(0xFF2C2E30),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await StaffContentService.deleteJob(opportunityId);
              _loadJobs();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'Manage Jobs',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.staffAddJob).then((_) => _loadJobs());
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadJobs,
          ),
        ],
      ),
      body: FutureBuilder<List<StaffJobModel>>(
        future: _jobsFuture,
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
          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return const Center(
              child: Text(
                'No jobs yet. Tap + to add one.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                color: const Color(0xFF2C2E30),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    job.positionTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Positions: ${job.numberAvailablePositions ?? 'N/A'} • Status: ${job.opportunityStatus}',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.staffEditJob,
                            arguments: job,
                          ).then((_) => _loadJobs());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteJob(job.opportunityId),
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
}