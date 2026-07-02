// lib/services/job_application_service.dart
// Handles applicant job applications (upload CV, submit)

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/job_application_model.dart';

class JobApplicationService {
  static final _supabase = Supabase.instance.client;

  /// Upload a CV to Supabase Storage and return the public URL
  static Future<String> uploadCv(File file, String applicantId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$applicantId.pdf';
    final filePath = 'cvs/$fileName';

    final response = await _supabase.storage.from('cvs').upload(
      filePath,
      file,
      fileOptions: const FileOptions(contentType: 'application/pdf'),
    );

    if (response.error != null) {
      throw Exception('Failed to upload CV: ${response.error?.message}');
    }

    // Get public URL
    final publicUrl = _supabase.storage.from('cvs').getPublicUrl(filePath);
    return publicUrl;
  }

  /// Submit a job application
  static Future<void> submitApplication({
    required int applicantId,
    required String opportunityId,
    required String cvUrl,
    required bool consentGiven,
  }) async {
    final applicationId = 'JA${DateTime.now().millisecondsSinceEpoch}';
    final application = JobApplicationModel(
      id: applicationId,
      applicantId: applicantId,
      opportunityId: opportunityId,
      applicationDate: DateTime.now(),
      status: 'pending',
      cvUrl: cvUrl,
      consentGiven: consentGiven,
      consentGivenAt: DateTime.now(),
    );

    final data = application.toJson();
    await _supabase.from('Job_Applications').insert(data);
  }

  /// Check if user has already applied to a job
  static Future<bool> hasApplied(int applicantId, String opportunityId) async {
    final response = await _supabase
        .from('Job_Applications')
        .select('Job_Application_id')
        .eq('Applicant_id', applicantId)
        .eq('Employment_Opportunity_id', opportunityId)
        .maybeSingle();

    return response != null;
  }
}