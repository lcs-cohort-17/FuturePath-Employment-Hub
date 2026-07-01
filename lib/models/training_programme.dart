class TrainingProgramme {
  final String programmeId; // programme_id (json)
  final String programmeName; // programme_name (json)
  final String programmeDescription; // programme_description (json)
  final DateTime startDate; // start_date (json)
  final DateTime endDate; // end_date (json)
  final int capacity; // capacity (json)
  final String programmeStatus; // programme_status (json)
  final List<String> requiredSkills; // required_skills (json)
  final String programmeCategory; // programme_category (json)

  // New fields
  final String? createdBy; // created_by (json)
  final String category; // category (json)
  final String level; // level (json)
  final String description; // description (json)
  final List<String> skills; // skills (json)
  final int durationMonths; // duration_months (json)
  final int enrolledCount; // enrolled_count (json)

  TrainingProgramme({
    required this.programmeId,
    required this.programmeName,
    required this.programmeDescription,
    required this.startDate,
    required this.endDate,
    required this.capacity,
    required this.programmeStatus,
    required this.requiredSkills,
    required this.programmeCategory,
    required this.createdBy,
    required this.category,
    required this.level,
    required this.description,
    required this.skills,
    required this.durationMonths,
    required this.enrolledCount,
  });

  // Convert a JSON object from Supabase into a TrainingProgramme object.
  factory TrainingProgramme.fromJson(Map<String, dynamic> json) {
    return TrainingProgramme(
      programmeId: json['programme_id'].toString(),
      programmeName: json['programme_name'] ?? '',
      programmeDescription: json['programme_description'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      capacity: int.tryParse(json['capacity'].toString()) ?? 0,
      programmeStatus: json['programme_status'] ?? '',
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
      programmeCategory: json['programme_category'] ?? '',

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
    );
  }

  // Convert a TrainingProgramme object into JSON for Supabase.
  Map<String, dynamic> toJson() {
    return {
      'programme_id': programmeId,
      'programme_name': programmeName,
      'programme_description': programmeDescription,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'capacity': capacity,
      'programme_status': programmeStatus,
      'required_skills': requiredSkills,
      'programme_category': programmeCategory,

      // New fields
      'created_by': createdBy,
      'category': category,
      'level': level,
      'description': description,
      'skills': skills,
      'duration_months': durationMonths,
      'enrolled_count': enrolledCount,
    };
  }
}