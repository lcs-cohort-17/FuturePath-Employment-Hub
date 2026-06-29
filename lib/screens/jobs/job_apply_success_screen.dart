// ukgfity
// Inside lib/screens/jobs/job_apply_success_screen.dart
import 'package:flutter/material.dart';

class JobApplySuccessScreen extends StatelessWidget {
  const JobApplySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
        // Technical Requirement: Use Navigator.pop from Success screen Close button
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Application Submitted!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Technical Requirement: Use Navigator.pushNamed for Track Application navigation
                  Navigator.pushNamed(context, '/track-applications');
                },
                child: const Text('Track Application'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}