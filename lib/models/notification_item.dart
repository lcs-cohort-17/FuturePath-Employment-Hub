class NotificationItem {
  final String id;
  final String type; // "programme" | "job" | "application"
  final String referenceId;
  final String title;
  final String body;
  final String timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.referenceId,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      type: json['type'] ?? 'application',
      referenceId: json['referenceId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      timestamp: json['timestamp'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }
}