// ✅ No PII — only anonymous applicant data
// Used for staff viewing applications.

class StaffApplicationModel {
  final String id;
  final String applicantId; // e.g., APP-001 — no personal info
  final String? applicantQualification;
  final String? cvUrl;
  final String status;
  final String? jobTitle;
  final String? companyName;
  final DateTime appliedAt;
  final DateTime updatedAt;

  StaffApplicationModel({
    required this.id,
    required this.applicantId,
    this.applicantQualification,
    this.cvUrl,
    required this.status,
    this.jobTitle,
    this.companyName,
    required this.appliedAt,
    required this.updatedAt,
  });

  factory StaffApplicationModel.fromJson(Map<String, dynamic> json) {
    return StaffApplicationModel(
      id: json['id'] ?? '',
      applicantId: json['applicant_id'] ?? json['applicant_af_id'] ?? '',
      applicantQualification: json['highest_qualification'],
      cvUrl: json['cv_url'],
      status: json['status'] ?? 'pending',
      jobTitle: json['position_title'],
      companyName: json['company_name'],
      appliedAt: json['applied_at'] != null ? DateTime.parse(json['applied_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }
}