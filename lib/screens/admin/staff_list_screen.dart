import 'package:flutter/material.dart';
import 'staff_detail_screen.dart';

class StaffListScreen extends StatelessWidget {
  const StaffListScreen({super.key});

  final List<Map<String, String>> mockStaff = const [
    {'id': 'STF-501', 'name': 'Dr. Sarah Miller', 'role': 'Senior Instructor'},
    {'id': 'STF-502', 'name': 'James Peterson', 'role': 'Placement Officer'},
    {'id': 'STF-503', 'name': 'Elena Rodriguez', 'role': 'Admin Coordinator'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Members'),
      ),
      body: ListView.separated(
        itemCount: mockStaff.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final staff = mockStaff[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(staff['name']?[0] ?? 'S'),
            ),
            title: Text(staff['name'] ?? ''),
            subtitle: Text(staff['role'] ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StaffDetailScreen(staffId: staff['id'] ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
