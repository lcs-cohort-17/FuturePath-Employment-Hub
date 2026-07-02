//user.profile
import 'programme.dart';

class UserProfile {
  final String id;
  final String name;
  final String displayName; // Added for compatibility
  final String? userId; // Added for compatibility
  final String location;
  final String employmentStatus;
  final bool isHired;
  final String email;
  final String? phone;
  final String? bio;
  final List<String> skills;
  final List<Programme> completedProgrammes;
  final List<Programme> enrolledProgrammes;
  final List<Programme> savedProgrammes; // Added for compatibility
  final String? profileImageUrl; // Added for compatibility
  final String? education; // Added for compatibility
  final String? experience; // Added for compatibility
  final String role; // NEW — matches Applicant.role in Supabase
  final String status; // NEW — matches Applicant.status in Supabase

  UserProfile({
    required this.id,
    required this.name,
    this.displayName = '',
    this.userId,
    required this.location,
    required this.employmentStatus,
    required this.isHired,
    required this.email,
    this.phone,
    this.bio,
    this.skills = const [],
    this.completedProgrammes = const [],
    this.enrolledProgrammes = const [],
    this.savedProgrammes = const [],
    this.profileImageUrl,
    this.education,
    this.experience,
    this.role = 'applicant',
    this.status = 'pending_approval',
  });

  /// Convenience getter used by AdminGuard and other role checks.
  bool get isAdmin => role == 'admin';

  // Copy with for updates
  UserProfile copyWith({
    String? name,
    String? displayName,
    String? userId,
    String? location,
    String? employmentStatus,
    bool? isHired,
    String? email,
    String? phone,
    String? bio,
    List<String>? skills,
    List<Programme>? completedProgrammes,
    List<Programme>? enrolledProgrammes,
    List<Programme>? savedProgrammes,
    String? profileImageUrl,
    String? education,
    String? experience,
    String? role,
    String? status,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      userId: userId ?? this.userId,
      location: location ?? this.location,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      isHired: isHired ?? this.isHired,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      completedProgrammes: completedProgrammes ?? this.completedProgrammes,
      enrolledProgrammes: enrolledProgrammes ?? this.enrolledProgrammes,
      savedProgrammes: savedProgrammes ?? this.savedProgrammes,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      education: education ?? this.education,
      experience: experience ?? this.experience,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  // Factory method to create from JSON (local/mock data)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? json['displayName'] ?? '',
      displayName: json['displayName'] ?? json['name'] ?? '',
      userId: json['userId'],
      location: json['location'] ?? '',
      employmentStatus: json['employmentStatus'] ?? 'Unemployed',
      isHired: json['isHired'] ?? false,
      email: json['email'] ?? '',
      phone: json['phone'],
      bio: json['bio'],
      skills: List<String>.from(json['skills'] ?? []),
      completedProgrammes: (json['completedProgrammes'] as List?)
          ?.map((e) => Programme.fromJson(e))
          .toList() ?? [],
      enrolledProgrammes: (json['enrolledProgrammes'] as List?)
          ?.map((e) => Programme.fromJson(e))
          .toList() ?? [],
      savedProgrammes: (json['savedProgrammes'] as List?)
          ?.map((e) => Programme.fromJson(e))
          .toList() ?? [],
      profileImageUrl: json['profileImageUrl'],
      education: json['education'],
      experience: json['experience'],
      role: json['role'] ?? 'applicant',
      status: json['status'] ?? 'pending_approval',
    );
  }

  /// Factory method to create from a raw Supabase 'Applicant' table row.
  /// Column names here match the Supabase schema exactly (PascalCase mix).
  factory UserProfile.fromSupabase(Map<String, dynamic> row) {
    final firstName = row['First_Name'] ?? '';
    final lastName = row['Last_Name'] ?? '';
    final fullName = '$firstName $lastName'.trim();

    return UserProfile(
      id: row['id'].toString(),
      name: fullName,
      displayName: fullName,
      userId: row['user_id'],
      location: row['Residential_Area'] ?? '',
      employmentStatus: row['Current_Employment_Status'] ?? 'Unemployed',
      isHired: false,
      email: row['Email'] ?? '',
      phone: row['contact_number'],
      bio: null,
      skills: row['Skills'] != null ? List<String>.from(row['Skills']) : const [],
      completedProgrammes: const [],
      enrolledProgrammes: const [],
      savedProgrammes: const [],
      profileImageUrl: null,
      education: row['Highest_Qualification'],
      experience: null,
      role: row['role'] ?? 'applicant',
      status: row['status'] ?? 'pending_approval',
    );
  }

  // Convert to JSON (local/mock data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'userId': userId,
      'location': location,
      'employmentStatus': employmentStatus,
      'isHired': isHired,
      'email': email,
      'phone': phone,
      'bio': bio,
      'skills': skills,
      'completedProgrammes': completedProgrammes.map((e) => e.toJson()).toList(),
      'enrolledProgrammes': enrolledProgrammes.map((e) => e.toJson()).toList(),
      'savedProgrammes': savedProgrammes.map((e) => e.toJson()).toList(),
      'profileImageUrl': profileImageUrl,
      'education': education,
      'experience': experience,
      'role': role,
      'status': status,
    };
  }
}