// lib/models/user_profile.dart
class UserProfile {
  final String id;
  final String name;
  final String location;
  final String employmentStatus;
  final bool isHired;
  final String email;
  final String phone;
  final String bio;
  final List<String> skills;
  final List<Programme> completedProgrammes;
  final List<Programme> enrolledProgrammes;

  UserProfile({
    required this.id,
    required this.name,
    required this.location,
    required this.employmentStatus,
    required this.isHired,
    required this.email,
    required this.phone,
    required this.bio,
    this.skills = const [],
    this.completedProgrammes = const [],
    this.enrolledProgrammes = const [],
  });

  // Copy with for updates
  UserProfile copyWith({
    String? name,
    String? location,
    String? employmentStatus,
    bool? isHired,
    String? email,
    String? phone,
    String? bio,
    List<String>? skills,
    List<Programme>? completedProgrammes,
    List<Programme>? enrolledProgrammes,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      location: location ?? this.location,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      isHired: isHired ?? this.isHired,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      completedProgrammes: completedProgrammes ?? this.completedProgrammes,
      enrolledProgrammes: enrolledProgrammes ?? this.enrolledProgrammes,
    );
  }
}