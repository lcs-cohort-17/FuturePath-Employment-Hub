class EmployerModel {
  final String id;
  final String companyName;
  final String industry;
  final String location;
  final String? website;
  final String? email;
  final String? bio;
  final int activeOpeningsCount;

  EmployerModel({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.location,
    this.website,
    this.email,
    this.bio,
    required this.activeOpeningsCount,
  });

  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      id: json['id'] ?? '',
      companyName: json['company_name'] ?? '',
      industry: json['industry'] ?? '',
      location: json['location'] ?? '',
      website: json['website'],
      email: json['email'],
      bio: json['bio'],
      activeOpeningsCount: json['active_openings_count'] ?? 0,
    );
  }
}