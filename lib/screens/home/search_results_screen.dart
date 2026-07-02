import 'package:flutter/material.dart';
import '../../core/widgets/loading_overlay.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import '../../services/sheets_service.dart';
// import '../../theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';


class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool hasError = false;
  List programmes = [];
  List opportunities = [];
  List results = [];
  final sheetsService = SheetsService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialQuery = ModalRoute.of(context)?.settings.arguments as String?;
      if (initialQuery != null) {
        searchController.text = initialQuery;
        onSearch(initialQuery);
      }
    });
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      programmes = await sheetsService.getProgrammes();
      opportunities = await sheetsService.getOpportunities();
      results = [...programmes, ...opportunities];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        results = [...programmes, ...opportunities];
      } else {
        final lowerQuery = query.toLowerCase();
        results = [
          ...programmes.where((p) =>
          (p['title']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
              (p['description']?.toString().toLowerCase().contains(lowerQuery) ?? false)
          ),
          ...opportunities.where((o) =>
          (o['title']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
              (o['company']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
              (o['description']?.toString().toLowerCase().contains(lowerQuery) ?? false)
          ),
        ];
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: LoadingOverlay());
    }

    if (hasError) {
      return Scaffold(
        body: ErrorMessage(
          message: "Something went wrong",
          onRetry: loadData,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          // Topbar
          Container(
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                bottom: BorderSide(color: AppTheme.border, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back, color: AppTheme.textDark, size: 20),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'FP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                const Text(
                  'Search',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Container(
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border, width: 0.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppTheme.subtleText, size: 16),
                const SizedBox(width: 7),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 12,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search jobs, programmes, skills…',
                      hintStyle: TextStyle(color: AppTheme.subtleText, fontSize: 12),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: onSearch,
                  ),
                ),
              ],
            ),
          ),

          // Results count
          if (results.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${results.length} result${results.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 10,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 4),

          // Results list
          Expanded(
            child: results.isEmpty
                ? const EmptyState(message: "No results found")
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                final String title = item['title']?.toString() ?? '';
                final String company = item['company']?.toString() ?? '';
                final String type = item['type']?.toString() ?? '';
                final List tags = item['tags'] is List
                    ? item['tags'] as List
                    : (item['tags']?.toString().isNotEmpty == true
                    ? [item['tags'].toString()]
                    : []);
                final String meta = item['location']?.toString() ?? '';
                final String closes = item['closes']?.toString() ?? '';
                final bool isOpen = item['status']?.toString().toLowerCase() == 'open' ||
                    item['status'] == null;

                return GestureDetector(
                  onTap: () {
                    // NAV-004 handles navigation
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppTheme.surface2,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.border, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppTheme.infoLow,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                company.isNotEmpty
                                    ? company.substring(0, company.length >= 2 ? 2 : 1).toUpperCase()
                                    : title.isNotEmpty
                                    ? title.substring(0, 1).toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: AppTheme.info,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 9),
                            // Title + company
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      color: AppTheme.textDark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (company.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Text(
                                        company,
                                        style: const TextStyle(
                                          color: AppTheme.mutedText,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Status badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: type.toLowerCase() == 'programme'
                                    ? AppTheme.infoLow
                                    : isOpen
                                    ? AppTheme.successLow
                                    : AppTheme.warningLow,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                type.toLowerCase() == 'programme'
                                    ? 'Programme'
                                    : isOpen
                                    ? '● Open'
                                    : '● Pending',
                                style: TextStyle(
                                  color: type.toLowerCase() == 'programme'
                                      ? AppTheme.info
                                      : isOpen
                                      ? AppTheme.success
                                      : AppTheme.warning,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Tags
                        if (tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface3,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: AppTheme.border, width: 0.5),
                                  ),
                                  child: Text(
                                    tag.toString(),
                                    style: const TextStyle(
                                      color: AppTheme.mutedText,
                                      fontSize: 9,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                        // Meta row
                        if (meta.isNotEmpty || closes.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Row(
                              children: [
                                if (meta.isNotEmpty) ...[
                                  const Icon(Icons.location_on_outlined,
                                      size: 10, color: AppTheme.subtleText),
                                  const SizedBox(width: 3),
                                  Text(
                                    meta,
                                    style: const TextStyle(
                                      color: AppTheme.subtleText,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                                if (meta.isNotEmpty && closes.isNotEmpty)
                                  const SizedBox(width: 10),
                                if (closes.isNotEmpty) ...[
                                  const Icon(Icons.access_time_outlined,
                                      size: 10, color: AppTheme.subtleText),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Closes $closes',
                                    style: const TextStyle(
                                      color: AppTheme.subtleText,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
