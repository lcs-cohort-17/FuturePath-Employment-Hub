class Opportunity {
    final int id;
    final String positionTitle;
    final int employerId; // or String if employerId is text
    final String location;
    final String jobType;
    final int salary; // or double if decimal
    final DateTime closingDate;
    final List<String> skills;
    final String description;
    final int availablePositions;

    Opportunity({
      required this.id,
      required this.positionTitle,
      required this.employerId,
      required this.location,
      required this.jobType,
      required this.salary,
      required this.closingDate,
      required this.skills,
      required this.description,
      required this.availablePositions,
    });

    factory Opportunity.fromRow(List<dynamic> row) {
      return Opportunity(
      id: int.parse(row[0].toString()),
      positionTitle: row[1].toString(),
      employerId: int.parse(row[2].toString()), // or row[2].toString() if text
      location: row[3].toString(),
      jobType: row[4].toString(),
      salary: int.parse(row[5].toString()),
      closingDate: DateTime.parse(row[6].toString()),
      skills: (row[7].toString().split(',').map((s) => s.trim()).toList()),
      description: row[8].toString(),
      availablePositions: int.parse(row[9].toString()),
    );
    }
}