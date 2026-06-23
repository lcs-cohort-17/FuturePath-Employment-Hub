import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import 'google_sheets_service.dart';
import '../models/application.dart';

class UserProfileService {
  final GoogleSheetsService _sheets = GoogleSheetsService();

  static const String _sheetName = 'UserProfilesSheet';

  Future<UserProfile?> fetchUserProfile(String userId) async {
    try {
      final rows = await _sheets.getRawRows(_sheetName);

      final index = rows.indexWhere(
            (row) => row.isNotEmpty && row.first.toString() == userId,
      );

      if (index == -1) {
        return null;
      }

      return UserProfile.fromRow(rows[index]);
    } catch (e) {
      debugPrint("Fetch UserProfile Error: $e");
      return null;
    }
  }

  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _sheets.appendRawRow(
        _sheetName,
        profile.toRow(),
      );
    } catch (e) {
      debugPrint("Create UserProfile Error: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final rows = await _sheets.getRawRows(_sheetName);

      final index = rows.indexWhere(
            (row) => row.isNotEmpty && row.first.toString() == profile.userId,
      );

      if (index == -1) {
        throw Exception("User profile not found.");
      }

      // +2 because:
      // row 1 = headers
      // data starts at row 2
      final rowNumber = index + 2;

      await _sheets.updateRawRow(
        _sheetName,
        rowNumber,
        profile.toRow(),
      );
    } catch (e) {
      debugPrint("Update UserProfile Error: $e");
      rethrow;
    }
  }

  // inside lib/services/user_profile_service.dart – add these methods below the existing ones

  // /// Add a new application to the user's profile
  // Future<void> addApplication(
  //     String userId,
  //     String jobId,
  //     String jobTitle,
  //     String status,
  //     ) async {
  //   final profile = await fetchUserProfile(userId);
  //   if (profile == null) throw Exception('User profile not found.');
  //
  //   // Append a new application map (matching the JSON format)
  //   profile.applications.add({
  //     'jobId': jobId,
  //     'title': jobTitle,
  //     'status': status,
  //     'userId': userId,
  //     'progress': 0,
  //   });
  //
  //   await updateUserProfile(profile);
  // }
  //
  // /// Update the progress of a programme in the user's history
  // Future<void> updateProgrammeProgress(
  //     String userId,
  //     String programmeId,
  //     int percentage,
  //     ) async {
  //   final profile = await fetchUserProfile(userId);
  //   if (profile == null) throw Exception('User profile not found.');
  //
  //   bool found = false;
  //   for (var prog in profile.programmeHistory) {
  //     if (prog['programmeId'] == programmeId) {
  //       prog['percentage'] = percentage;
  //       prog['status'] = (percentage == 100)
  //           ? 'completed'
  //           : (percentage > 0 ? 'in-progress' : 'enrolled');
  //       found = true;
  //       break;
  //     }
  //   }
  //   if (!found) throw Exception('Programme $programmeId not found.');
  //
  //   await updateUserProfile(profile);
  // }
  //
  // /// Fetch all applications as Application objects
  // Future<List<Application>> getUserApplications(String userId) async {
  //   final profile = await fetchUserProfile(userId);
  //   if (profile == null) return [];
  //
  //   return profile.applications
  //       .map((map) => Application.fromJson(map))
  //       .toList();
  // }


  // ----- YOUR NEW METHODS (ticket) -----

  /// Add a new application to the user's profile
  Future<void> addApplication(
      String userId,
      String jobId,
      String jobTitle,
      String status,
      ) async {
    final profile = await fetchUserProfile(userId);
    if (profile == null) throw Exception('User profile not found.');

    profile.applications.add({
      'jobId': jobId,
      'title': jobTitle,
      'status': status,
      'userId': userId,
      'progress': 0,
    });

    await updateUserProfile(profile);
  }

  /// Update the progress of a programme in the user's history
  Future<void> updateProgrammeProgress(
      String userId,
      String programmeId,
      int percentage,
      ) async {
    final profile = await fetchUserProfile(userId);
    if (profile == null) throw Exception('User profile not found.');

    bool found = false;
    for (var prog in profile.programmeHistory) {
      if (prog['programmeId'] == programmeId) {
        prog['percentage'] = percentage;
        prog['status'] = (percentage == 100)
            ? 'completed'
            : (percentage > 0 ? 'in-progress' : 'enrolled');
        found = true;
        break;
      }
    }
    if (!found) throw Exception('Programme $programmeId not found.');

    await updateUserProfile(profile);
  }

  /// Fetch all applications as Application objects (using fromRow)
  Future<List<Application>> getUserApplications(String userId) async {
    final profile = await fetchUserProfile(userId);
    if (profile == null) return [];

    return profile.applications.map((map) {
      return Application.fromRow([
        0,                                              // id (placeholder)
        map['jobId']?.toString() ?? '',                // jobId
        map['title']?.toString() ?? '',                // title
        map['status']?.toString() ?? '',               // status
        map['userId']?.toString() ?? '',               // userId
        map['progress'] ?? 0,                          // progress
      ]);
    }).toList();
  }
}