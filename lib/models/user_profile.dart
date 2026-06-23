import 'dart:convert';

class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String idNumber;
  final String qualification;
  final String bio;
  final List<String> skills;
  final String cvUrl;
  final List<Map<String, dynamic>> programmeHistory;
  final List<Map<String, dynamic>> applications;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.idNumber,
    required this.qualification,
    required this.bio,
    required this.skills,
    required this.cvUrl,
    required this.programmeHistory,
    required this.applications,
  });

  factory UserProfile.fromRow(List<dynamic> row) {
    return UserProfile(
      userId: row[0].toString(),
      name: row[1].toString(),
      email: row[2].toString(),
      phone: row[3].toString(),
      idNumber: row[4].toString(),
      qualification: row[5].toString(),
      bio: row[6].toString(),
      skills: _decodeSkills(row[7]),
      cvUrl: row[8].toString(),
      programmeHistory: _decodeMapList(row[9]),
      applications: _decodeMapList(row[10]),
    );
  }

  List<dynamic> toRow() {
    return [
      userId,
      name,
      email,
      phone,
      idNumber,
      qualification,
      bio,
      jsonEncode(skills),
      cvUrl,
      jsonEncode(programmeHistory),
      jsonEncode(applications),
    ];
  }

  static List<String> _decodeSkills(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return [];
    }

    try {
      return List<String>.from(jsonDecode(value.toString()));
    } catch (_) {
      return [];
    }
  }

  static List<Map<String, dynamic>> _decodeMapList(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return [];
    }

    try {
      return List<Map<String, dynamic>>.from(
        jsonDecode(value.toString()),
      );
    } catch (_) {
      return [];
    }
  }
}