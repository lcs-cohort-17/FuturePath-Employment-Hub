class NotificationItem {
  final String id;
  final String type; // "programme" | "job" | "application"
  final String referenceId;
  final String title;
  final String body;
  final String timestamp;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.referenceId,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? type,
    String? referenceId,
    String? title,
    String? body,
    String? timestamp,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'referenceId': referenceId,
      'title': title,
      'body': body,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}