// Thrown when the service fails (invalid filter or repository error)
class ActivityLogException implements Exception {
  final String message;
  const ActivityLogException(this.message);

  @overrride
  String toString() => 'ActivityLogException: $message';
}