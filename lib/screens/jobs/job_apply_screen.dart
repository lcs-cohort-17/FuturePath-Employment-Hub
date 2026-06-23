import 'package:flutter/material.dart';
import 'job_apply_success_screen.dart';

class ApplyScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  // Constructor automatically accepts the passed parameters
  const ApplyScreen({
    super.key, 
    required this.jobId, 
    required this.jobTitle,
  });

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jobController;

  @override
  void initState() {
    super.initState();
    // Acceptance Criteria: Auto-populating fields with passed arguments
    _jobController = TextEditingController(text: '${widget.jobTitle} (${widget.jobId})');
  }

  @override
  void dispose() {
    super.dispose();
    _jobController.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Application')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _jobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Applying For Position',
                  prefixIcon: Icon(Icons.work_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Contact Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Field required' : null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // SUBTASK 2: Use pushReplacement so user cannot pop back to this form
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SuccessScreen(jobTitle: widget.jobTitle)),
                      );
                    }
                  },
                  child: const Text('Submit Application', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}