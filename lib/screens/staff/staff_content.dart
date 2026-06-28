// TODO: Replace with final design (PO-UIUX-011)
// Placeholder for staff content/activity.

import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import '../../services/staff_dashboard_service.dart';

class StaffContent extends StatefulWidget {
  const StaffContent({super.key});

  @override
  State<StaffContent> createState() => _StaffContentState();
}

class _StaffContentState extends State<StaffContent> {
  late Future<Map<String, dynamic>> _statsFuture;
  late Future<List<Map<String, dynamic>>> _logFuture;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final userId = _auth.currentUser?.id;
    if (userId != null) {
      setState(() {
        // ✅ FIXED: Call static methods directly on the class
        _statsFuture = StaffDashboardService.getDashboardStats(userId);
        _logFuture = StaffDashboardService.getStaffActivityLog(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'My Activity',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats — only counts, no PII
              const Text(
                'Overview',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              FutureBuilder<Map<String, dynamic>>(
                future: _statsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  final stats = snapshot.data ?? {};
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard('Total Applications', stats['total_applications']?.toString() ?? '0', Colors.blue),
                      _buildStatCard('Enrollments', stats['total_enrollments']?.toString() ?? '0', Colors.green),
                      _buildStatCard('Completion Rate', '${stats['completion_rate']?.toString() ?? 0}%', Colors.orange),
                      _buildStatCard('Active Jobs', stats['active_jobs']?.toString() ?? '0', const Color(0xFFE03A2F)),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Activity Log
              const Text(
                'My Action Log',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _logFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  final logs = snapshot.data ?? [];
                  if (logs.isEmpty) {
                    return const Text(
                      'No activity yet.',
                      style: TextStyle(color: Colors.white54),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return Card(
                        color: const Color(0xFF2C2E30),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            _getActionIcon(log['action']),
                            color: _getActionColor(log['action']),
                          ),
                          title: Text(
                            '${log['action']} ${log['entity_type']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            log['details']?['title'] ?? 'No details',
                            style: const TextStyle(color: Colors.white54),
                          ),
                          trailing: Text(
                            _formatTime(log['created_at']),
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Privacy Notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: const Text(
                  'No applicant personal data is shown here.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      color: const Color(0xFF2C2E30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActionIcon(String? action) {
    switch (action) {
      case 'created':
        return Icons.add_circle_outline;
      case 'updated':
        return Icons.edit_outlined;
      case 'deleted':
        return Icons.delete_outline;
      default:
        return Icons.info_outline;
    }
  }

  Color _getActionColor(String? action) {
    switch (action) {
      case 'created':
        return Colors.green;
      case 'updated':
        return Colors.blue;
      case 'deleted':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final time = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(time);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return '';
    }
  }
}