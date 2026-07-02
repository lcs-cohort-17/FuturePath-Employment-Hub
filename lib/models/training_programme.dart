class TrainingProgramme {
  final String programmeId; // programme_id (json)
  final String? createdBy; // created_by (json)
  final String programmeName; // programme_name (json)
  final String category; // category (json)
  final String level; // level (json)
  final String description; // description (json)
  final List<String> skills; // skills (json)
  final int durationMonths; // duration_months (json)
  final int enrolledCount; // enrolled_count (json)
  final String programmeDescription; // programme_description (json)
  final DateTime startDate; // start_date (json)
  final DateTime endDate; // end_date (json)
  final int capacity; // capacity (json)
  final String programmeStatus; // programme_status (json)
  final List<String> requiredSkills; // required_skills (json)
  final String programmeCategory; // programme_category (json)
  final String sfId;

  // New fields


  TrainingProgramme({
    required this.programmeId,
    required this.createdBy,
    required this.category,
    required this.level,
    required this.description,
    required this.skills,
    required this.durationMonths,
    required this.enrolledCount,
    required this.programmeName,
    required this.programmeDescription,
    required this.startDate,
    required this.endDate,
    required this.capacity,
    required this.programmeStatus,
    required this.requiredSkills,
    required this.programmeCategory,
    required this.sfId
  });

  // Convert a JSON object from Supabase into a TrainingProgramme object.
  factory TrainingProgramme.fromJson(Map<String, dynamic> json) {
    return TrainingProgramme(
      programmeId: json['programme_id'].toString(),
      // New fields
      createdBy: json['created_by']?.toString(),
      category: json['category'] ?? '',
      level: json['level'] ?? '',
      description: json['description'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      durationMonths:
      int.tryParse(json['duration_months'].toString()) ?? 0,
      enrolledCount:
      int.tryParse(json['enrolled_count'].toString()) ?? 0,
      programmeName: json['Programme_Name'] ?? '',
      programmeDescription: json['Programme_Description'] ?? '',
      startDate: DateTime.parse(json['Start_Date']),
      endDate: DateTime.parse(json['End_Date']),
      capacity: int.tryParse(json['Capacity'].toString()) ?? 0,
      programmeStatus: json['Programme_Status'] ?? '',
      requiredSkills: List<String>.from(json['Required_Skills'] ?? []),
      programmeCategory: json['Programme_Category'] ?? '',
      sfId: json['sf_id'] ?? '',


    );
  }

  // Convert a TrainingProgramme object into JSON for Supabase.
  Map<String, dynamic> toJson() {
    return {
      'programme_id': programmeId,
      // New fields
      'created_by': createdBy,
      'category': category,
      'level': level,
      'description': description,
      'skills': skills,
      'duration_months': durationMonths,
      'enrolled_count': enrolledCount,
      'Programme_Name': programmeName,
      'Programme_Description': programmeDescription,
      'Start_Date': startDate.toIso8601String(),
      'End_Date': endDate.toIso8601String(),
      'Capacity': capacity,
      'Programme_Status': programmeStatus,
      'Required_Skills': requiredSkills,
      'Programme_Category': programmeCategory,
      'sf_id': sfId,
    };
  }
}