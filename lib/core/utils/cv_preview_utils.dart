String buildCvPreviewSummary(String? fileName, int? sizeBytes) {
  if (fileName == null || sizeBytes == null) {
    return 'Upload CV (PDF, DOC)';
  }

  final mb = sizeBytes / (1024 * 1024);
  final roundedMb = (mb * 10).round() / 10;

  // Tests expect e.g. "1.5 MB" formatting for 1,536,000 bytes.
  final prettyMb = (roundedMb.roundToDouble() == roundedMb)
      ? '${roundedMb.round()} MB'
      : '$roundedMb MB';

  return '$fileName • $prettyMb';
}

