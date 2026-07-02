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
  final String? contactPerson;
  final String? website;
  final String? description;
  final DateTime? createdAt;
  final int? activeOpportunities;
  final String? sfId;

  const Employer({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.location,
    this.contactEmail,
    this.contactPhone,
    this.contactPerson,
    this.website,
    this.description,
    this.createdAt,
    this.activeOpportunities,
    this.sfId,
  });

  // ── Supabase-compatible deserialization ──────────────────────────────────

  factory Employer.fromMap(Map<String, dynamic> map) {
    return Employer(
      id: map['employer_id']?.toString() ?? '',
      companyName: map['Company_Name']?.toString() ?? '',
      industry: map['Industry']?.toString() ?? '',
      location: map['Company_Location']?.toString() ?? '',
      contactEmail: map['Email']?.toString(),
      contactPhone: map['Contact_Number']?.toString(),
      contactPerson: map['Contact_Person']?.toString(),
      activeOpportunities: map['active_opportunities'] as int?,
      sfId: map['sf_id']?.toString(),
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
      'Email': contactEmail ?? '',
      'Contact_Number': contactPhone ?? '',
      'Contact_Person': contactPerson ?? '',
      if (activeOpportunities != null)
        'active_opportunities': activeOpportunities,
      if (sfId != null)
        'sf_id': sfId,
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
    String? contactPerson,
    String? website,
    String? description,
    DateTime? createdAt,
    int? activeOpportunities,
    String? sfId,
  }) {
    return Employer(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      location: location ?? this.location,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      contactPerson: contactPerson ?? this.contactPerson,
      website: website ?? this.website,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      activeOpportunities: activeOpportunities ?? this.activeOpportunities,
      sfId: sfId ?? this.sfId,
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
      id: json['employer_id']?.toString() ?? '',
      companyName: json['Company_Name']?.toString() ?? '',
      industry: json['Industry']?.toString() ?? '',
      location: json['Company_Location']?.toString() ?? '',
      email: json['Email']?.toString(),
      website: json['sf_id']?.toString(),
      activeOpeningsCount: json['active_opportunities'] as int? ?? 0,
    );
  }
}
