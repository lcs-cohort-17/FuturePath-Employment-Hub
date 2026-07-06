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
  final String? idNumber; // Added
  final String? dateOfBirth; // Added
  final String? gender; // Added
  final List<String> skills;
  final List<Programme> completedProgrammes;
  final List<Programme> enrolledProgrammes;
  final List<Programme> savedProgrammes; // Added for compatibility
  final String? profileImageUrl; // Added for compatibility
  final String? education; // Added for compatibility
  final String? experience; // Added for compatibility

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
    this.idNumber,
    this.dateOfBirth,
    this.gender,
    this.skills = const [],
    this.completedProgrammes = const [],
    this.enrolledProgrammes = const [],
    this.savedProgrammes = const [],
    this.profileImageUrl,
    this.education,
    this.experience,
  });

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
    String? idNumber,
    String? dateOfBirth,
    String? gender,
    List<String>? skills,
    List<Programme>? completedProgrammes,
    List<Programme>? enrolledProgrammes,
    List<Programme>? savedProgrammes,
    String? profileImageUrl,
    String? education,
    String? experience,
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
      idNumber: idNumber ?? this.idNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      skills: skills ?? this.skills,
      completedProgrammes: completedProgrammes ?? this.completedProgrammes,
      enrolledProgrammes: enrolledProgrammes ?? this.enrolledProgrammes,
      savedProgrammes: savedProgrammes ?? this.savedProgrammes,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      education: education ?? this.education,
      experience: experience ?? this.experience,
    );
  }

  // Factory method to create from JSON
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
      idNumber: json['idNumber'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
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
    );
  }

  // Convert to JSON
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
      'idNumber': idNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'skills': skills,
      'completedProgrammes': completedProgrammes.map((e) => e.toJson()).toList(),
      'enrolledProgrammes': enrolledProgrammes.map((e) => e.toJson()).toList(),
      'savedProgrammes': savedProgrammes.map((e) => e.toJson()).toList(),
      'profileImageUrl': profileImageUrl,
      'education': education,
      'experience': experience,
    };
  }
}