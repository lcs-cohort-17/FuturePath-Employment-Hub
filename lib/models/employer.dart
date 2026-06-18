class Employer {
  final int id;
  final String companyName;
  final String industry;
  final String location;
  final String contactPerson;
  final String contactNumber;
  final String email;

  Employer({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.location,
    required this.contactPerson,
    required this.contactNumber,
    required this.email,
  });

  factory Employer.fromRow(List<dynamic> row) {
    return Employer(
        id: int.parse(row[0].toString()) ,
        companyName: row[1].toString(),
        industry: row[2].toString(),
        location: row[3].toString(),
        contactPerson: row[4].toString(),
        contactNumber: row[5].toString(),
        email: row[6].toString()
    );
  }
}