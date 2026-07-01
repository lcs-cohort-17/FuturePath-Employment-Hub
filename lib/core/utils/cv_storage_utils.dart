import 'dart:io';

import '../../models/user_profile.dart';



/// Writes CV bytes to a local folder.
///
/// Target path (Windows/desktop):
///   <projectRoot>/cv/resume/<userId>/<sanitizedFileName>
///
/// Notes:
/// - This is intended for mobile/desktop builds where we can access the filesystem.
/// - For web builds, this will not work.
class CvStorageUtils {

  /// Attempts to resolve the project root by using the location of this file.
  /// Falls back to current working directory if it can't.
  static Future<String> _resolveProjectRoot() async {
    try {
      // lib/core/utils/cv_storage_utils.dart -> go up 3 levels to reach repo root
      // (utils -> core -> lib). Then we're at repo root.
      final file = File('lib/core/utils/cv_storage_utils.dart');
      if (file.existsSync()) {
        // Using cwd is more reliable at runtime.
        // We'll use a deterministic relative path from current working dir.
        return Directory.current.path;
      }
    } catch (_) {
      // ignore
    }
    return Directory.current.path;
  }

  static String _sanitizeFileName(String rawFileName) {
    // Keep letters, digits, dot, dash and underscore.
    final cleaned = rawFileName
        .replaceAll(RegExp(r'\\'), '_')
        .replaceAll(RegExp(r'\/+'), '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');

    if (cleaned.trim().isEmpty) return 'cv_file';
    return cleaned;
  }

  /// Writes bytes to `cv/resume/<userId>/...`.
  ///
  /// Returns the absolute file path if successful.
  static Future<String> saveCvToLocalResumeFolder({
    required UserProfile profile,
    required String fileName,
    required List<int> bytes,
  }) async {
    final projectRoot = await _resolveProjectRoot();
    final sanitized = _sanitizeFileName(fileName);

    // Use a stable user directory.
    final userDir = profile.id.isNotEmpty ? profile.id : 'unknown_user';

    final targetDir = Directory('$projectRoot/cv/resume/$userDir');
    if (!targetDir.existsSync()) {
      targetDir.createSync(recursive: true);
    }

    final targetPath = '${targetDir.path}/$sanitized';
    final targetFile = File(targetPath);
    await targetFile.writeAsBytes(bytes, flush: true);
    return targetPath;
  }
}

