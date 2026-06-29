// hgfy

// Inside lib/screens/jobs/job_apply_screen.dart
import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/models/application.dart';
import 'job_apply_success_screen.dart';

class JobApplyScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const JobApplyScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<JobApplyScreen> createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends State<JobApplyScreen> {
  // Example controllers if you want to pre-fill form fields
  late TextEditingController _jobTitleController;

  @override
  void initState() {
    super.initState();
    // Pre-filling the field automatically using the passed widget data
    _jobTitleController = TextEditingController(text: widget.jobTitle);
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    super.dispose();
  }

  void _handleFormSubmit() {
    // Mocking the submission logic
    final newApplication = Application(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobId: widget.jobId,
      jobTitle: widget.jobTitle,
      appliedDate: DateTime.now(),
      status: 'Pending',
    );
    
    Application.submittedApplications.add(newApplication);

    // Technical Requirement: Use Navigator.pushReplacement on successful submission
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const JobApplySuccessScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Job')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _jobTitleController,
              decoration: const InputDecoration(labelText: 'Job Position'),
              readOnly: true, // keeps it pre-filled and uneditable if desired
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _handleFormSubmit,
              child: const Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }
}