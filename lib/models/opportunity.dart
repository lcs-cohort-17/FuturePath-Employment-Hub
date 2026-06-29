class Opportunity {
  final String id;
  final String title;
  final String company;
  final String description;
  final String location;
  final String type; // e.g., Full-time, Internship

  Opportunity({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.location,
    required this.type,
  });
}
