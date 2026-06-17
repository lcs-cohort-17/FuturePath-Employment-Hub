class RegistrationService {
  static Future<void> saveApplicant({
    required String firstName,
    required String lastName,
    required String idNumber,
    required String dateOfBirth,
    required String gender,
    required String contactNumber,
    required String email,
    required String residentialArea,
    required String highestQualification,
    required String employmentStatus,
    required List<String> skills,
  }) async {
    // TODO: Implement actual registration logic
    // For now, just simulate a delay
    await Future.delayed(const Duration(milliseconds: 500));
    print('Applicant registered: $email');
  }
}