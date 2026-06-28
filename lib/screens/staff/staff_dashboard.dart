// TODO: Replace with final design (PO-UIUX-008)
// ✅ Uses AppRouter for navigation

import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import '../../services/staff_dashboard_service.dart';
import '../../router/app_router.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  late Future<Map<String, dynamic>> _statsFuture;
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    final userId = _auth.currentUser?.id;
    if (userId != null) {
      setState(() {
        _statsFuture = StaffDashboardService.getDashboardStats(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text(
          'Staff Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, ${_auth.currentUser?.email?.split('@').first ?? 'Staff'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Staff Account',
                style: TextStyle(color: Color(0xFFE03A2F), fontSize: 14),
              ),
              const SizedBox(height: 24),

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
                      _buildStatCard('Total Jobs', stats['total_jobs']?.toString() ?? '0', Colors.blue),
                      _buildStatCard('Active Jobs', stats['active_jobs']?.toString() ?? '0', Colors.green),
                      _buildStatCard('Total Programmes', stats['total_programmes']?.toString() ?? '0', Colors.orange),
                      _buildStatCard('Active Programmes', stats['active_programmes']?.toString() ?? '0', const Color(0xFFE03A2F)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              const Text(
                'Quick Actions',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildActionButton('Add Job', Icons.add, () {
                    Navigator.pushNamed(context, AppRouter.staffAddJob);
                  }),
                  const SizedBox(width: 12),
                  _buildActionButton('Add Programme', Icons.add_box, () {
                    Navigator.pushNamed(context, AppRouter.staffAddProgramme);
                  }),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildActionButton('View Analytics', Icons.analytics, () {
                    Navigator.pushNamed(context, '/staff/content');
                  }),
                  const SizedBox(width: 12),
                  _buildActionButton('My Activity', Icons.history, () {
                    Navigator.pushNamed(context, '/staff/content');
                  }),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildActionButton('View Applications', Icons.assignment, () {
                    Navigator.pushNamed(context, '/staff/applications');
                  }),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: const Text(
                  'Applicant personal data is never visible to staff.',
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

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C2E30),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}