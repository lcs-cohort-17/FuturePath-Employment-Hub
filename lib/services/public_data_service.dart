//Qaasim sprint 2 ticket 022 UIUX
Future<List<Map<String, dynamic>>> getApplicationsForJob(String jobId) async {
  await Future.delayed(const Duration(milliseconds: 800));
  return [];
}
//Onke/021 Starts Here
// Add to lib/services/public_data_service.dart — inside the PublicDataService class

Future<void> updateApplicationStatus(
    String applicationId,
    String newStatus,
    ) async {
  await Future.delayed(const Duration(milliseconds: 400));
}
//Qaasim ticket 022 UIUX ends here.
/// Returns enrolments for a given programme. Returns no PII — applicant
/// identity is represented only by the anonymised applicant_id_c column.
Future<List<Map<String, dynamic>>> getEnrolmentsForProgramme(
    String programmeId) async {
  // [SUPABASE-INTEGRATION] — Replace mock with:
  // return await supabase
  //   .from('enrolments')
  //   .select('applicant_id_c, qualification, status')
  //   .eq('programme_id', programmeId);
  return [];
}

/// Updates the status of a single enrolment. Uses only the anonymised
/// applicant ID — never PII.
Future<void> updateEnrolmentStatus(
    String applicantId, String newStatus) async {
  // [SUPABASE-INTEGRATION] — Replace mock with:
  // await supabase
  //   .from('enrolments')
  //   .update({'status': newStatus})
  //   .eq('applicant_id_c', applicantId);
}
//Onke/Ends Here