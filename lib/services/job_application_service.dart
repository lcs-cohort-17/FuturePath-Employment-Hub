// lib/services/job_application_service.dart
// Handles applicant job applications (upload CV, submit, check applied)

import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/job_application_model.dart';

class JobApplicationService {
  static final _supabase = Supabase.instance.client;
  static const String _supabaseUrl = 'https://nzwoxvpcljzitldzepwc.supabase.co';

  // ─── CV UPLOAD ──────────────────────────────────────────────────────────

  static Future<String> uploadCv(File file, String userId) async {
    print('📤 [uploadCv] Starting upload for userId: $userId');
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$userId.pdf';
      final filePath = 'cvs/$fileName';
      print('📁 Uploading to bucket path: $filePath');

      await _supabase.storage.from('User Cv pdf').upload(
        filePath,
        file,
        fileOptions: const FileOptions(contentType: 'application/pdf'),
      );
      final publicUrl = _supabase.storage.from('User Cv pdf').getPublicUrl(filePath);
      print('✅ Upload successful, URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload CV: $e');
    }
  }

  static Future<String> uploadCvFromBytes(
      Uint8List bytes,
      String userId,
      String fileName,
      ) async {
    print('📤 [uploadCvFromBytes] Starting upload for userId: $userId');
    try {
      final baseUrl = _supabaseUrl;
      final bucketName = 'User Cv pdf';
      final path = 'cvs/${DateTime.now().millisecondsSinceEpoch}_$userId.pdf';
      final url = '$baseUrl/storage/v1/object/$bucketName/$path';

      final session = _supabase.auth.currentSession;
      final token = session?.accessToken ?? '';
      if (token.isEmpty) throw Exception('No access token available');

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: fileName),
      );

      final response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final publicUrl = _supabase.storage.from(bucketName).getPublicUrl(path);
        print('✅ Upload successful, URL: $publicUrl');
        return publicUrl;
      } else {
        final body = await response.stream.bytesToString();
        throw Exception('Upload failed: ${response.statusCode} - $body');
      }
    } catch (e) {
      throw Exception('Failed to upload CV from bytes: $e');
    }
  }

  // ─── MOTIVATIONAL LETTER UPLOAD ────────────────────────────────────────

  static Future<String> uploadMotivationalLetter(File file, String userId) async {
    print('📤 [uploadMotivationalLetter] Starting upload for userId: $userId');
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$userId.pdf';
      final filePath = 'motivational_letters/$fileName';
      print('📁 Uploading to bucket path: $filePath');

      await _supabase.storage.from('User Cv pdf').upload(
        filePath,
        file,
        fileOptions: const FileOptions(contentType: 'application/pdf'),
      );
      final publicUrl = _supabase.storage.from('User Cv pdf').getPublicUrl(filePath);
      print('✅ Motivational letter uploaded, URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload motivational letter: $e');
    }
  }

  static Future<String> uploadMotivationalLetterFromBytes(
      Uint8List bytes,
      String userId,
      String fileName,
      ) async {
    print('📤 [uploadMotivationalLetterFromBytes] Starting upload for userId: $userId');
    try {
      final baseUrl = _supabaseUrl;
      final bucketName = 'User Cv pdf';
      final path = 'motivational_letters/${DateTime.now().millisecondsSinceEpoch}_$userId.pdf';
      final url = '$baseUrl/storage/v1/object/$bucketName/$path';

      final session = _supabase.auth.currentSession;
      final token = session?.accessToken ?? '';
      if (token.isEmpty) throw Exception('No access token available');

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: fileName),
      );

      final response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final publicUrl = _supabase.storage.from(bucketName).getPublicUrl(path);
        print('✅ Motivational letter uploaded, URL: $publicUrl');
        return publicUrl;
      } else {
        final body = await response.stream.bytesToString();
        throw Exception('Upload failed: ${response.statusCode} - $body');
      }
    } catch (e) {
      throw Exception('Failed to upload motivational letter from bytes: $e');
    }
  }

  // ─── SUBMIT APPLICATION ─────────────────────────────────────────────────

  static Future<void> submitApplication({
    required int applicantId,
    required String opportunityId,
    required String cvUrl,
    String? motivationalLetterUrl, // NEW (optional)
    required bool consentGiven,
  }) async {
    print('📝 [submitApplication] Starting submission');
    try {
      final applicationId = 'JA${DateTime.now().millisecondsSinceEpoch}';
      final application = JobApplicationModel(
        id: applicationId,
        applicantId: applicantId,
        opportunityId: opportunityId,
        applicationDate: DateTime.now(),
        status: 'pending',
        cvUrl: cvUrl,
        motivationalLetterUrl: motivationalLetterUrl,
        consentGiven: consentGiven,
        consentGivenAt: DateTime.now(),
      );

      final data = application.toJson();
      print('📦 Payload: $data');
      await _supabase.from('Job_Applications').insert(data);
      print('✅ Insert successful.');
    } catch (e) {
      print('❌ Submit failed: $e');
      rethrow;
    }
  }

  // ─── GET APPLICATIONS FOR APPLICANT ────────────────────────────────────

  static Future<List<Map<String, dynamic>>> getApplicationsForApplicant(int applicantId) async {
    print('🔍 [getApplicationsForApplicant] applicantId: $applicantId');
    try {
      final response = await _supabase
          .from('Job_Applications')
          .select('''
            Job_Application_id,
            Application_Status,
            Application_Date,
            Employment_Opportunity_id,
            "Employment Opportunity" (
              Position_Title
            )
          ''')
          .eq('Applicant_id', applicantId)
          .order('Application_Date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error: $e');
      return [];
    }
  }

  // ─── CHECK IF APPLIED ──────────────────────────────────────────────────

  static Future<bool> hasApplied(int applicantId, String opportunityId) async {
    try {
      final response = await _supabase
          .from('Job_Applications')
          .select('Job_Application_id')
          .eq('Applicant_id', applicantId)
          .eq('Employment_Opportunity_id', opportunityId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }
}