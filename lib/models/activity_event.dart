// Public event - no PII fields.
class ActivityEvent {
  final String type;
  final String description;
  final DateTime timestamp;

  const ActivityEvent({
    required this.type,
    required this.description,
    required this.timestamp,
});

  @override
  String toString() =>
      'ActivityEvent(type: $type, description: $description, timestamp: $timestamp)';
}