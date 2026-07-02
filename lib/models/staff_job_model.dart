// ✅ Uses actual column names from employment_opportunities table

class StaffJobModel {
  final String opportunityId;
  final String? opportunityNumber;
  final String positionTitle;
  final String? positionDescription;
  final List<String>? requiredSkills;
  final DateTime? closingDate;
  final String opportunityStatus;
  final int? numberAvailablePositions;
  final String? employerId;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StaffJobModel({
    required this.opportunityId,
    this.opportunityNumber,
    required this.positionTitle,
    this.positionDescription,
    this.requiredSkills,
    this.closingDate,
    required this.opportunityStatus,
    this.numberAvailablePositions,
    this.employerId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffJobModel.fromJson(Map<String, dynamic> json) {
    return StaffJobModel(
      opportunityId: json['opportunity_id'] ?? '',
      opportunityNumber: json['opportunity_number'],
      positionTitle: json['Position_Title'] ?? json['position_title'] ?? '',
      positionDescription: json['Position_Description'] ?? json['position_description'],
      requiredSkills: json['Required_Skills'] is List ? List<String>.from(json['Required_Skills']) : (json['required_skills'] is List ? List<String>.from(json['required_skills']) : []),
      closingDate: json['Closing_Date'] != null ? DateTime.parse(json['Closing_Date']) : (json['closing_date'] != null ? DateTime.parse(json['closing_date']) : null),
      opportunityStatus: json['Opportunity_Status'] ?? json['opportunity_status'] ?? 'draft',
      numberAvailablePositions: json['Number_Of_Available_Positions'] ?? json['number_available_positions'],
      employerId: json['employer_id'],
      createdBy: json['Created_By'] ?? json['created_by'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opportunity_id': opportunityId,
      'opportunity_number': opportunityNumber,
      'Position_Title': positionTitle,
      'Position_Description': positionDescription,
      'Required_Skills': requiredSkills,
      'Closing_Date': closingDate?.toIso8601String().split('T').first,
      'Opportunity_Status': opportunityStatus,
      'Number_Of_Available_Positions': numberAvailablePositions,
      'employer_id': employerId,
      'Created_By': createdBy,
    };
  }
}