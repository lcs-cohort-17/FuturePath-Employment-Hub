import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/core/utils/cv_preview_utils.dart';

void main() {
  group('CV preview helpers', () {
    test('buildCvPreviewSummary returns file details for a selected CV', () {
      final summary = buildCvPreviewSummary('My_CV.pdf', 1536000);

      expect(summary, contains('My_CV.pdf'));
      expect(summary, contains('1.5 MB'));
    });

    test('buildCvPreviewSummary falls back to the upload prompt', () {
      expect(buildCvPreviewSummary(null, null), 'Upload CV (PDF, DOC)');
    });
  });
}
