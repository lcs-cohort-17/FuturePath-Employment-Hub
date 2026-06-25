import '../models/raw_event.dart';

// Internal raw event
class RawEvent {
  final String id;
  final String type;
  final String description;
  final DateTime timestamp;
  final String? userName;
  final String? userEmail;
  final String? userId;

  const RawEvent ({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    this.userName,
    this.userEmail,
    thisuserId,
});
}

// Repository abstraction for fetching raw events.
abstract class IEventRepository {
  Future<List<RawEVent>> getEvents();
}