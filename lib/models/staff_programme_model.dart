// ✅ Uses actual column names from Training Programme table

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
      programmeName: json['Programme_Name'] ?? '',
      programmeDescription: json['Programme_Description'],
      startDate: json['Start_Date'] != null ? DateTime.parse(json['Start_Date']) : null,
      endDate: json['End_Date'] != null ? DateTime.parse(json['End_Date']) : null,
      capacity: json['Capacity'],
      programmeStatus: json['Programme_Status'] ?? 'draft',
      requiredSkills: json['Required_Skills'] is List ? List<String>.from(json['Required_Skills']) : [],
      programmeCategory: json['Programme_Category'],
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
      'programme_id': programmeId,
      'Programme_Name': programmeName,
      'Programme_Description': programmeDescription,
      'Start_Date': startDate?.toIso8601String().split('T').first,
      'End_Date': endDate?.toIso8601String().split('T').first,
      'Capacity': capacity,
      'Programme_Status': programmeStatus,
      'Required_Skills': requiredSkills,
      'Programme_Category': programmeCategory,
      'created_by': createdBy,
      'category': category,
      'level': level,
      'skills': skills,
      'duration_months': durationMonths,
      'enrolled_count': enrolledCount,
    };
  }
}