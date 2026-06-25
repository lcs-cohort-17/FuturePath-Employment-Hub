// Thrown when the service fails (invalid filter or repository error)
class ActivityLogException implements Exception {
  final String message;
  const ActivityLogException(this.message);

  @override
  String toString() => 'ActivityLogException: $message';
}