import 'package:flutter/material.dart';

class StaffDetailScreen extends StatelessWidget {
  final String staffId;

  const StaffDetailScreen({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Column(
              children: [
                Text(
                  'Dr. Sarah Miller',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Senior Instructor — Computer Science',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Email'),
            subtitle: Text('sarah.miller@futurepath.com'),
          ),
          const ListTile(
            leading: Icon(Icons.phone_outlined),
            title: Text('Phone'),
            subtitle: Text('+27 82 123 4567'),
          ),
          const ListTile(
            leading: Icon(Icons.badge_outlined),
            title: Text('Employee ID'),
            subtitle: Text('STF-501'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Bio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dr. Miller has over 15 years of experience in academia and industry. She specializes in mobile application development and distributed systems.',
            style: TextStyle(height: 1.5),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}
