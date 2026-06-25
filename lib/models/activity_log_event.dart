/// Category of an anonymised activity event shown on the Admin Activity
/// Log screen. Drives icon + colour selection only — never carries or
/// implies any personally identifiable information.
enum ActivityEventCategory {
  application,
  enrollment,
  staffPending,
  staffApproved,
  staffRejected,
}

/// A single anonymised activity log entry.
///
/// IMPORTANT: This model must never contain PII (names, emails, phone
/// numbers, ID numbers). Only [type], [description], and [timestamp] are
/// shown to admins, per INT-013's acceptance criteria.
class ActivityLogEvent {
  final String type;
  final String description;
  final DateTime timestamp;
  final ActivityEventCategory category;

  const ActivityLogEvent({
    required this.type,
    required this.description,
    required this.timestamp,
    required this.category,
  });
}