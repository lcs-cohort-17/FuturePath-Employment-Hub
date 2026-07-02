// lib/models/job_application_model.dart
// Model for Job_Applications table

class JobApplicationModel {
  final String id;
  final int applicantId;
  final String opportunityId;
  final DateTime applicationDate;
  final String status;
  final String? cvUrl;
  final String? motivationalLetterUrl; // NEW
  final bool consentGiven;
  final DateTime? consentGivenAt;

  JobApplicationModel({
    required this.id,
    required this.applicantId,
    required this.opportunityId,
    required this.applicationDate,
    required this.status,
    this.cvUrl,
    this.motivationalLetterUrl, // NEW
    required this.consentGiven,
    this.consentGivenAt,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      id: json['Job_Application_id'] ?? '',
      applicantId: json['Applicant_id'] ?? 0,
      opportunityId: json['Employment_Opportunity_id'] ?? '',
      applicationDate: json['Application_Date'] != null
          ? DateTime.parse(json['Application_Date'])
          : DateTime.now(),
      status: json['Application_Status'] ?? 'pending',
      cvUrl: json['cv_url'],
      motivationalLetterUrl: json['motivational_letter_url'], // NEW
      consentGiven: json['consent_given'] ?? false,
      consentGivenAt: json['consent_given_at'] != null
          ? DateTime.parse(json['consent_given_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Job_Application_id': id,
      'Applicant_id': applicantId,
      'Employment_Opportunity_id': opportunityId,
      'Application_Date': applicationDate.toIso8601String().split('T').first,
      'Application_Status': status,
      'cv_url': cvUrl,
      'motivational_letter_url': motivationalLetterUrl, // NEW
      'consent_given': consentGiven,
      'consent_given_at': consentGivenAt?.toIso8601String(),
    };
  }
}