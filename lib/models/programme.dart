//programme.dart
class Programme {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final List<String> skills;
  final String? duration;
  final String? level;
  final List<String>? requirements;
  final String status;
  final bool isCompleted;
  final double progress;
  final String? certificateUrl; // Added this field

  const Programme({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.skills = const [],
    this.duration,
    this.level,
    this.requirements,
    required this.status,
    required this.isCompleted,
    this.progress = 0.0,
    this.certificateUrl, // Added
  });

  factory Programme.fromJson(Map<String, dynamic> json) {
    return Programme(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      skills: List<String>.from(json['skills'] ?? []),
      duration: json['duration'],
      level: json['level'],
      requirements: json['requirements'] != null 
          ? List<String>.from(json['requirements']) 
          : null,
      status: json['status'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      progress: (json['progress'] ?? 0.0).toDouble(),
      certificateUrl: json['certificateUrl'], // Added
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'skills': skills,
      'duration': duration,
      'level': level,
      'requirements': requirements,
      'status': status,
      'isCompleted': isCompleted,
      'progress': progress,
      'certificateUrl': certificateUrl, // Added
    };
  }

  factory Programme.fromSimple({
    required String id,
    required String name,
    required String status,
    required bool isCompleted,
    double progress = 0.0,
    String? certificateUrl,
  }) {
    return Programme(
      id: id,
      name: name,
      status: status,
      isCompleted: isCompleted,
      progress: progress,
      certificateUrl: certificateUrl,
    );
  }

  Programme toSimple() {
    return Programme(
      id: id,
      name: name,
      status: status,
      isCompleted: isCompleted,
      progress: progress,
      certificateUrl: certificateUrl,
    );
  }
}
