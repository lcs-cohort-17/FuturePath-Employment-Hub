import 'package:flutter/material.dart';
import '../../services/staff_registration_service.dart';

class AdminStaffMgmtScreen extends StatefulWidget {
  const AdminStaffMgmtScreen({super.key});

  @override
  State<AdminStaffMgmtScreen> createState() => _AdminStaffMgmtScreenState();
}

class _AdminStaffMgmtScreenState extends State<AdminStaffMgmtScreen> {
  late Future<List<Map<String, dynamic>>> _pendingStaffFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _pendingStaffFuture = StaffRegistrationService.getPendingStaff();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Staff Management', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(onPressed: _refreshList, icon: const Icon(Icons.refresh, color: Colors.white))
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pendingStaffFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE03A2F)));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)));
          }
          
          final pending = snapshot.data ?? [];

          if (pending.isEmpty) {
            return const Center(child: Text('No pending requests', style: TextStyle(color: Colors.white24)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final staff = pending[index];
              return _buildStaffCard(staff);
            },
          );
        },
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> staff) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2E30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${staff['first_name']} ${staff['last_name']}', 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          Text(staff['company_name'] ?? 'Unknown Company', style: const TextStyle(color: Color(0xFFE03A2F), fontSize: 14)),
          const SizedBox(height: 8),
          Text(staff['email_address'] ?? staff['email'] ?? 'No email', style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await StaffRegistrationService.updateStaffStatus(staff['user_id'], 'active');
                    _refreshList();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Approve'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await StaffRegistrationService.updateStaffStatus(staff['user_id'], 'suspended');
                    _refreshList();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Reject'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
