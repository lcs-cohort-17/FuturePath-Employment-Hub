import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import 'google_sheets_service.dart';

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
}