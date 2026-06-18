class Programme {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int capacity;
  final String status; // keep it as String for simplicity
  final List<String> skills;
  final String category;

  Programme({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.capacity,
    required this.status,
    required this.skills,
    required this.category,
  });

  // Convert a row (List<dynamic>) from the sheet to a Programme object.
  factory Programme.fromRow(List<dynamic> row) {
  return Programme(
    id: int.parse(row[0].toString()),
    name: row[1].toString(),
    description: row[2].toString(),
    startDate: DateTime.parse(row[3].toString()),
    endDate: DateTime.parse(row[4].toString()),
    capacity: int.parse(row[5].toString()),
    status: row[6].toString(), // dropdown value as string
    skills: (row[7].toString().split(',').map((s) => s.trim()).toList()),
    category: row[8].toString(),
  );
  }
}