// lib/utils/id_generator.dart
// Generates short, unique IDs that fit in VARCHAR(7) columns.

class IdGenerator {
  static int _lastTimestamp = 0;
  static int _counter = 0;

  static String _generateShortId(String prefix) {
    // Get current time in milliseconds
    final now = DateTime.now().millisecondsSinceEpoch;

    // If the timestamp changed, reset the counter
    if (now != _lastTimestamp) {
      _lastTimestamp = now;
      _counter = 0;
    } else {
      _counter++;
    }

    // Use last 3 digits of timestamp (0–999) + 1 digit counter (0–9)
    // Total = 3 + 1 = 4 digits, which fits after the 3‑letter prefix.
    final timePart = (now % 1000).toString().padLeft(3, '0');
    final counterPart = (_counter % 10).toString();
    final uniqueSuffix = '$timePart$counterPart';

    return '$prefix$uniqueSuffix';
  }

  static String generateOpportunityId() => _generateShortId('OPP');
  static String generateOpportunityNumber() => _generateShortId('ON');
  static String generateProgrammeId() => _generateShortId('PRG');

  // ✅ Generate enrolment ID (e.g., ENR1234)
  static String generateEnrolmentId() => _generateShortId('ENR');
}