/// Internal raw event – can contain PII fields.
/// This is never exposed to the UI.
class RawEvent {
  final String id;
  final String type;
  final String description;
  final DateTime timestamp;
  final String? userName;
  final String? userEmail;
  final String? userId;

  const RawEvent({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    this.userName,
    this.userEmail,
    this.userId,
  });
}