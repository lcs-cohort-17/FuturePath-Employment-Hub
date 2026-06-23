import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationService {
  static const _keyApplicants = 'applicants';

  static Future<void> saveApplicant({
    required String firstName,
    required String lastName,
    required String idNumber,
    required String dateOfBirth,
    required String gender,
    required String contactNumber,
    required String email,
    required String residentialArea,
    required String highestQualification,
    required String employmentStatus,
    required List<String> skills,
    String programmeHistory = '',
    String applicationStatus = 'Pending',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing applicants
    final existing = prefs.getString(_keyApplicants);
    final List<dynamic> applicants = existing != null ? jsonDecode(existing) : [];

    // Build new applicant record
    final applicant = {
      'firstName': firstName,
      'lastName': lastName,
      'idNumber': idNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'contactNumber': contactNumber,
      'email': email,
      'residentialArea': residentialArea,
      'highestQualification': highestQualification,
      'employmentStatus': employmentStatus,
      'skills': skills,
      'programmeHistory': programmeHistory,
      'applicationStatus': applicationStatus,
      'registeredAt': DateTime.now().toIso8601String(),
    };

    applicants.add(applicant);
    await prefs.setString(_keyApplicants, jsonEncode(applicants));
  }

  static Future<List<Map<String, dynamic>>> getApplicants() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_keyApplicants);
    if (existing == null) return [];
    final List<dynamic> decoded = jsonDecode(existing);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}