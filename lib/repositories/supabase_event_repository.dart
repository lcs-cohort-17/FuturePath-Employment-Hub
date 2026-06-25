import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/raw_event.dart';
import 'event_repository.dart';

class SupabaseEventRepository implements IEventRepository {
  final SupabaseClient client;

  SupabaseEventRepository(this.client);

  @override
  Future<List<RawEvent>> getEvents() async {
    try {
      final response = await client
          .from('activity_logs')
          .select('id, type, description, created_at, user_name, user_email, user_id')
          .order('created_at', ascending: false);

      return response.map((json) {
        // Scrub description of any PII (extra safety)
        final rawDescription = json['description'] as String? ?? '';
        final safeDescription = _removePiiFromText(rawDescription);

        return RawEvent(
          id: json['id'] as String,
          type: json['type'] as String,
          description: safeDescription,
          timestamp: DateTime.parse(json['created_at'] as String),
          userName: json['user_name'] as String?,
          userEmail: json['user_email'] as String?,
          userId: json['user_id'] as String?,
        );
      }).toList();
    } catch (e) {
      // Rethrow so the service can handle it
      throw Exception('Supabase fetch failed: $e');
    }
  }

  /// Simple PII scrubber – adjust the regex to your needs.
  String _removePiiFromText(String text) {
    // Remove emails
    String result = text.replaceAll(RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w+\b'), '[REDACTED]');
    // Remove UUID-like IDs
    result = result.replaceAll(RegExp(r'[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}'), '[REDACTED]');
    // Optionally remove common name patterns (adjust as needed)
    // result = result.replaceAll(RegExp(r'\b[A-Z][a-z]+ [A-Z][a-z]+\b'), '[REDACTED]');
    return result;
  }
}