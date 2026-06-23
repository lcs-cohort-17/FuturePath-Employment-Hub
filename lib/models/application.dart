// lib/models/application.dart
class Application {
  final int id;
  final int jobId;
  final int userId;
  final String status;
  final String title;
  final int progress;

  Application({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.status,
    required this.title,
    required this.progress,
  });

  factory Application.fromRow(List<dynamic> row) {
    return Application(
      id: int.parse(row[0].toString()),
      jobId: int.parse(row[1].toString()),
      title: row[2].toString(),
      status: row[3].toString(),
      userId: int.parse(row[4].toString()),
      progress: int.parse(row[5].toString()),
    );
  }

// Map<String, dynamic> toJson() => {
//   'id': id,
//   'jobId': jobId,
//   'title': title,
//   'status': status,
//   'userId': userId,
//   'progress': progress,
// };
}