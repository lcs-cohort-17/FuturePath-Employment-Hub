// lib/utils/id_generator.dart
// Generates short IDs that fit in character varying(7) columns

class IdGenerator {
  static int _counter = 0;

  static String _generateShortId(String prefix) {
    _counter++;
    // Format: prefix + 4-digit number (e.g., OPP0001, ON0001, PRG0001)
    return '$prefix${_counter.toString().padLeft(4, '0')}';
  }

  static String generateOpportunityId() {
    return _generateShortId('OPP');
  }

  static String generateOpportunityNumber() {
    return _generateShortId('ON');
  }

  static String generateProgrammeId() {
    return _generateShortId('PRG');
  }

  // Reset counter if needed (for testing)
  static void resetCounter() {
    _counter = 0;
  }
}