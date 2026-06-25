// lib/services/search_filter_service.dart

class SearchFilterService {
  SearchFilterService._();

  static List<dynamic> searchAll({
    required String query,
    required List programmes,
    required List opportunities,
  }) {
    final allItems = [
      ...programmes,
      ...opportunities,
    ];

    if (query.trim().isEmpty) {
      return allItems;
    }

    final searchTerm = query.toLowerCase().trim();

    return allItems.where((item) {
      if (item is! Map) return false;

      final title =
          item['title']?.toString().toLowerCase() ?? '';

      final description =
          item['description']?.toString().toLowerCase() ?? '';

      final type =
          item['type']?.toString().toLowerCase() ?? '';

      return title.contains(searchTerm) ||
          description.contains(searchTerm) ||
          type.contains(searchTerm);
    }).toList();
  }
}