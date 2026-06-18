import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_profile_provider.dart';
import '../../providers/applications_provider.dart';
import 'job_apply_success_screen.dart';

class JobApplyScreen extends StatefulWidget {
  final String userId;
  final String jobId;
  final String jobTitle;

  const JobApplyScreen({
    super.key,
    required this.userId,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<JobApplyScreen> createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends State<JobApplyScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final idNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  PlatformFile? selectedCv;
  bool isSubmitting = false;
  bool profileLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!profileLoaded) {
      final userProfileProvider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );

      final profile = userProfileProvider.userProfile;

      if (profile != null) {
        fullNameController.text = profile.fullName;
        idNumberController.text = profile.idNumber;
        emailController.text = profile.email;
        phoneController.text = profile.phone;
      }

      profileLoaded = true;
    }
  }

  Future<void> pickCvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedCv = result.files.first;
      });
    }
  }

  Future<void> submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCv == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your CV before submitting.'),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final applicationsProvider = Provider.of<ApplicationsProvider>(
        context,
        listen: false,
      );

      await applicationsProvider.addApplication(
        widget.userId,
        widget.jobId,
        widget.jobTitle,
        "Pending",
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => JobApplySuccessScreen(
            jobTitle: widget.jobTitle,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit application: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    idNumberController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Job'),
      ),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.jobTitle,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: fullNameController,
                        decoration: inputDecoration('Full Name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: idNumberController,
                        decoration: inputDecoration('SA ID Number'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'SA ID number is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: emailController,
                        decoration: inputDecoration('Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: phoneController,
                        decoration: inputDecoration('Phone'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      OutlinedButton.icon(
                        onPressed: pickCvFile,
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          selectedCv == null
                              ? 'Upload CV PDF/DOC'
                              : selectedCv!.name,
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                          isSubmitting ? null : submitApplication,
                          child: const Text(
                            'Submit Application',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}