/// Employer model.
///
/// Field names mirror the expected Supabase column names so that
/// [Employer.fromMap] can be called directly on a Supabase row response
/// and [toMap] can be passed directly to an insert / update call.
class Employer {
  final String id;
  final String companyName;
  final String industry;
  final String location;
  final String? contactEmail;
  final String? contactPhone;
  final String? website;
  final String? description;
  final DateTime? createdAt;

  const Employer({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.location,
    this.contactEmail,
    this.contactPhone,
    this.website,
    this.description,
    this.createdAt,
  });

  // ── Supabase-compatible deserialization ──────────────────────────────────

  factory Employer.fromMap(Map<String, dynamic> map) {
    return Employer(
      id: map['employer_id']?.toString() ?? map['id']?.toString() ?? '',
      companyName: map['Company_Name']?.toString() ?? map['company_name']?.toString() ?? '',
      industry: map['Industry']?.toString() ?? map['industry']?.toString() ?? '',
      location: map['Company_Location']?.toString() ?? map['location']?.toString() ?? '',
      contactEmail: map['Email']?.toString() ?? map['contact_email']?.toString(),
      contactPhone: map['Contact_Number']?.toString() ?? map['contact_phone']?.toString(),
      website: map['website']?.toString(),
      description: map['description']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }

  // ── Supabase-compatible serialization ────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      'Company_Name': companyName,
      'Industry': industry,
      'Company_Location': location,
      if (contactEmail != null && contactEmail!.isNotEmpty)
        'Email': contactEmail,
      if (contactPhone != null && contactPhone!.isNotEmpty)
        'Contact_Number': contactPhone,
      if (website != null && website!.isNotEmpty) 'website': website,
      if (description != null && description!.isNotEmpty)
        'description': description,
    };
  }

  // ── Immutable update helper ───────────────────────────────────────────────

  Employer copyWith({
    String? id,
    String? companyName,
    String? industry,
    String? location,
    String? contactEmail,
    String? contactPhone,
    String? website,
    String? description,
    DateTime? createdAt,
  }) {
    return Employer(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      location: location ?? this.location,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'Employer(id: $id, companyName: $companyName, industry: $industry, location: $location)';
}

/// A UI-facing model used by the Employer Detail screen.
///
/// [EmployerModel] provides the data structure required by the
/// Employer Detail screen and its corresponding tests.
class EmployerModel {
  final String id;
  final String companyName;
  final String industry;
  final String location;
  final String? email;
  final String? website;
  final String? bio;
  final int activeOpeningsCount;

  const EmployerModel({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.location,
    this.email,
    this.website,
    this.bio,
    this.activeOpeningsCount = 0,
  });

  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      id: json['id']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      industry: json['industry']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      email: json['email']?.toString(),
      website: json['website']?.toString(),
      bio: json['bio']?.toString(),
      activeOpeningsCount: json['active_openings_count'] as int? ?? 0,
    );
  }
}
