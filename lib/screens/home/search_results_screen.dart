import 'package:flutter/material.dart';
import '../../core/widgets/loading_overlay.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import '../../services/public_data_service.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import '../../models/programme.dart';
import '../../models/staff_job_model.dart';
import '../../screens/jobs/job_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool hasError = false;
  List<Programme> programmes = [];
  List<StaffJobModel> opportunities = [];
  List<dynamic> results = [];

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
      programmes = await PublicDataService.getProgrammes();
      opportunities = await PublicDataService.getJobs();
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
          p.title.toLowerCase().contains(lowerQuery) ||
              p.description.toLowerCase().contains(lowerQuery)
          ),
          ...opportunities.where((o) =>
          o.positionTitle.toLowerCase().contains(lowerQuery) ||
              (o.positionDescription?.toLowerCase().contains(lowerQuery) ?? false)
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

                String title = '';
                String subtitle = '';
                String typeLabel = '';
                bool isOpen = true;
                List<String> tags = [];
                StaffJobModel? jobModel;

                if (item is Programme) {
                  title = item.title;
                  subtitle = item.provider;
                  typeLabel = 'Programme';
                  isOpen = item.status.toLowerCase() == 'open';
                  tags = item.skills;
                } else if (item is StaffJobModel) {
                  title = item.positionTitle;
                  subtitle = 'Job Opportunity';
                  typeLabel = 'Job';
                  isOpen = item.opportunityStatus.toLowerCase() == 'open';
                  tags = item.requiredSkills ?? [];
                  jobModel = item;
                }

                return GestureDetector(
                  onTap: () {
                    if (item is StaffJobModel) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StaffJobDetailScreen(job: item),
                        ),
                      );
                    } else if (item is Programme) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Programme detail: $title')),
                      );
                    }
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
                                title.isNotEmpty ? title[0].toUpperCase() : '?',
                                style: const TextStyle(
                                  color: AppTheme.info,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 9),
                            // Title + subtitle
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
                                  if (subtitle.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Text(
                                        subtitle,
                                        style: const TextStyle(
                                          color: AppTheme.mutedText,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Show "Apply" button for jobs, type label for programmes
                            if (item is StaffJobModel)
                              _applyButton(item)
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item is Programme
                                      ? AppTheme.infoLow
                                      : isOpen
                                      ? AppTheme.successLow
                                      : AppTheme.warningLow,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  typeLabel,
                                  style: TextStyle(
                                    color: item is Programme
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
                                    tag,
                                    style: const TextStyle(
                                      color: AppTheme.mutedText,
                                      fontSize: 9,
                                    ),
                                  ),
                                );
                              }).toList(),
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

  Widget _applyButton(StaffJobModel job) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StaffJobDetailScreen(job: job),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          'Apply',
          style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}