// ✅ Uses actual column names from training_programmes table

class StaffProgrammeModel {
  final String programmeId;
  final String programmeName;
  final String? programmeDescription;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? capacity;
  final String programmeStatus;
  final List<String>? requiredSkills;
  final String? programmeCategory;
  final String? createdBy;
  final String? category;
  final String? level;
  final List<String>? skills;
  final int? durationMonths;
  final int? enrolledCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StaffProgrammeModel({
    required this.programmeId,
    required this.programmeName,
    this.programmeDescription,
    this.startDate,
    this.endDate,
    this.capacity,
    required this.programmeStatus,
    this.requiredSkills,
    this.programmeCategory,
    this.createdBy,
    this.category,
    this.level,
    this.skills,
    this.durationMonths,
    this.enrolledCount,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffProgrammeModel.fromJson(Map<String, dynamic> json) {
    return StaffProgrammeModel(
      programmeId: json['programme_id'] ?? '',
      programmeName: json['programme_name'] ?? '',
      programmeDescription: json['programme_description'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      capacity: json['capacity'],
      programmeStatus: json['programme_status'] ?? 'draft',
      requiredSkills: json['required_skills'] is List ? List<String>.from(json['required_skills']) : [],
      programmeCategory: json['programme_category'],
      createdBy: json['created_by'],
      category: json['category'],
      level: json['level'],
      skills: json['skills'] is List ? List<String>.from(json['skills']) : [],
      durationMonths: json['duration_months'],
      enrolledCount: json['enrolled_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'programme_id': programmeId,  // ✅ IMPORTANT: This was missing!
      'programme_name': programmeName,
      'programme_description': programmeDescription,
      'start_date': startDate?.toIso8601String().split('T').first,
      'end_date': endDate?.toIso8601String().split('T').first,
      'capacity': capacity,
      'programme_status': programmeStatus,
      'required_skills': requiredSkills,
      'programme_category': programmeCategory,
      'created_by': createdBy,
      'category': category,
      'level': level,
      'skills': skills,
      'duration_months': durationMonths,
      'enrolled_count': enrolledCount,
    };
  }
}