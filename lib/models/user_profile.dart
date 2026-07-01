//user.profile
import 'programme.dart';

class UserProfile {
  final String id;
  final String name;

  // Added for compatibility
  final String displayName;
  final String? userId;

  final String location;
  final String employmentStatus;
  final bool isHired;

  final String email;
  final String? phone;
  final String? bio;

  final List<String> skills;
  final List<Programme> completedProgrammes;
  final List<Programme> enrolledProgrammes;

  // Added for compatibility
  final List<Programme> savedProgrammes;
  final String? profileImageUrl;
  final String? education;
  final String? experience;

  // CV persistence (tests expect these)
  final String? cvFileName;
  final List<int>? cvFileBytes;

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
    this.cvFileName,
    this.cvFileBytes,
  });

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
    String? cvFileName,
    List<int>? cvFileBytes,
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
      cvFileName: cvFileName ?? this.cvFileName,
      cvFileBytes: cvFileBytes ?? this.cvFileBytes,
    );
  }

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
              .toList() ??
          [],
      enrolledProgrammes: (json['enrolledProgrammes'] as List?)
              ?.map((e) => Programme.fromJson(e))
              .toList() ??
          [],
      savedProgrammes: (json['savedProgrammes'] as List?)
              ?.map((e) => Programme.fromJson(e))
              .toList() ??
          [],
      profileImageUrl: json['profileImageUrl'],
      education: json['education'],
      experience: json['experience'],
      cvFileName: json['cvFileName'],
      cvFileBytes: json['cvFileBytes'] != null
          ? List<int>.from(json['cvFileBytes'] as List)
          : null,
    );
  }

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
      'completedProgrammes':
          completedProgrammes.map((e) => e.toJson()).toList(),
      'enrolledProgrammes':
          enrolledProgrammes.map((e) => e.toJson()).toList(),
      'savedProgrammes': savedProgrammes.map((e) => e.toJson()).toList(),
      'profileImageUrl': profileImageUrl,
      'education': education,
      'experience': experience,
      'cvFileName': cvFileName,
      'cvFileBytes': cvFileBytes,
    };
  }
}

