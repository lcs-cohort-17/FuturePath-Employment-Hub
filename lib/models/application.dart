class Application {
  final String id;
  final String jobId;
  final String jobTitle;
  final DateTime appliedDate;
  final String status;

  Application({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.appliedDate,
    required this.status,
  });

  // For demonstration purposes, a simple static list to store applications
  static List<Application> submittedApplications = [];
}
