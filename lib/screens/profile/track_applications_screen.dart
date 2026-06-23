import 'package:flutter/material.dart';

class TrackApplicationsScreen extends StatelessWidget {
  const TrackApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Applications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Card(
              child: ListTile(
                leading: Icon(Icons.hourglass_top, color: Colors.orange),
                title: Text('Junior Mobile Developer (Flutter)'),
                subtitle: Text('Status: Submitted to Salesforce Database'),
                trailing: Chip(label: Text('Pending')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}