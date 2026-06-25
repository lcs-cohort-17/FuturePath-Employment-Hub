// Qaasim [UIUX-022] — Tap target to open applications for this job (admin role only)
// Show this button only when the current user role is admin
GestureDetector(
onTap: () => context.pushNamed(
'adminJobApplications',
pathParameters: {'jobId': job.id},
queryParameters: {'jobTitle': job.title},
),
child: /* your "View Applications" button widget */,
),
// Qaasim ticket UIUX 022 ends here.