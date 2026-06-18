
class SearchFilterService {
  static List<dynamic> searchAll({
    required String query,
    required List<dynamic> programmes,
    required List<dynamic> opportunities,
  }) {
    if (query.trim().isEmpty) {
      return [
        ...programmes,
        ...opportunities,
      ];
    }

    final lower = query.toLowerCase();

    final programmeResults = programmes.where((programme) {
      return programme["title"].toString().toLowerCase().contains(lower) ||
          programme["description"].toString().toLowerCase().contains(lower) ||
          programme["skills"].toString().toLowerCase().contains(lower);
    }).toList();

    final opportunityResults = opportunities.where((opportunity) {
      return opportunity["title"].toString().toLowerCase().contains(lower) ||
          opportunity["company"].toString().toLowerCase().contains(lower) ||
          opportunity["description"].toString().toLowerCase().contains(lower) ||
          opportunity["skills"].toString().toLowerCase().contains(lower);
    }).toList();

    return [
      ...programmeResults,
      ...opportunityResults,
    ];
  }

  static List<dynamic> filterOpportunitiesByLocation({
    required List<dynamic> opportunities,
    required List<String> locations,
  }) {
    if (locations.isEmpty) {
      return opportunities;
    }

    return opportunities.where((opportunity) {
      return locations.contains(opportunity["location"]);
    }).toList();
  }
}