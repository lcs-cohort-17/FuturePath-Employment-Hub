// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-004
// ═══════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import '../../services/sheets_service.dart';
import '../../core/widgets/loading_overlay.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import 'programme_detail_screen.dart';
// ─────────────────────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────────────────────
class ProgrammeListScreen extends StatefulWidget {
  const ProgrammeListScreen({super.key});

  @override
  State<ProgrammeListScreen> createState() => _ProgrammeListScreenState();
}

class _ProgrammeListScreenState extends State<ProgrammeListScreen> {
  final SheetsService sheetsService = SheetsService();

  List<Programme> programmes = [];
  bool isLoading = true;
  bool hasError = false;
  DateTime? lastUpdated;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _categories = [
    'All',
    'Technology',
    'Business',
    'Marketing',
    'Engineering',
  ];

  @override
  void initState() {
    super.initState();
    loadProgrammes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadProgrammes() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    programmes = mockProgrammes;
    lastUpdated = DateTime.now();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleRefresh() async {
    await loadProgrammes();
  }

  List<Programme> get _filteredProgrammes {
    return programmes.where((programme) {
      final matchesCategory = _selectedCategory == 'All' ||
          programme.category == _selectedCategory;

      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          programme.title.toLowerCase().contains(query) ||
          programme.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: LoadingOverlay(),
      );
    }

    if (hasError) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: ErrorMessage(
          message: "Failed to load programmes",
          onRetry: loadProgrammes,
        ),
      );
    }

    if (programmes.isEmpty) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: EmptyState(message: "No programmes found"),
      );
    }

    final filtered = _filteredProgrammes;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text(
          "Programmes",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
      ),
      body: RefreshIndicator(
        color: AppTheme.primary,
        backgroundColor: AppTheme.card,
        onRefresh: _handleRefresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lastUpdated != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Last updated ${DateTime.now().difference(lastUpdated!).inMinutes} min ago",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedText,
                  ),
                ),
              ),

            // SEARCH
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search programmes...",
                  hintStyle: const TextStyle(color: AppTheme.mutedText, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.mutedText, size: 20),
                  filled: true,
                  fillColor: AppTheme.card,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                  ),
                ),
              ),
            ),

            // CATEGORY FILTERS
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category == _selectedCategory;

                  return FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: selected ? Colors.white : AppTheme.mutedText,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: AppTheme.card,
                    selectedColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: selected
                          ? BorderSide.none
                          : const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "${filtered.length} programmes found",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mutedText,
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final programme = filtered[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProgrammeDetailScreen(
                            programme: programme,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: ProgrammeCard(programme: programme),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────
// PROGRAMME CARD - Updated to match dark theme
// ─────────────────────────────────────────────────────────────
class ProgrammeCard extends StatelessWidget {
  final Programme programme;

  const ProgrammeCard({
    super.key,
    required this.programme,
  });

  @override
  Widget build(BuildContext context) {
    final spotsLeft = programme.spotsRemaining;
    final progress = programme.capacity == 0
        ? 0.0
        : programme.enrolledCount / programme.capacity;

    final isOpen = programme.status.toLowerCase() == 'open';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    programme.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOpen
                        ? AppTheme.accent.withValues(alpha: 0.15)
                        : AppTheme.mutedText.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isOpen ? AppTheme.accent : AppTheme.mutedText,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        programme.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isOpen ? AppTheme.accent : AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "${programme.provider} • ${programme.level}",
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.mutedText,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: programme.skills.take(3).map((skill) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.mutedText,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 14,
                  color: AppTheme.mutedText,
                ),
                const SizedBox(width: 6),
                Text(
                  "$spotsLeft spots remaining",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: AppTheme.secondary,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════════════

class Programme {
  final String id;
  final String title;
  final String provider;
  final String category;
  final String level;
  final String duration;
  final String startDate;
  final String endDate;
  final String description;
  final String careerOpportunities;
  final List<String> skills;
  final int capacity;
  final int enrolledCount;
  final String status;

  int get spotsRemaining => capacity - enrolledCount;

  const Programme({
    required this.id,
    required this.title,
    required this.provider,
    required this.category,
    required this.level,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.careerOpportunities,
    required this.skills,
    required this.capacity,
    required this.enrolledCount,
    required this.status,
  });
}

final List<Programme> mockProgrammes = [
  const Programme(
    id: '1',
    title: 'Software Development Bootcamp',
    provider: 'FuturePath Academy',
    category: 'Technology',
    level: 'Beginner',
    duration: '6 Months',
    startDate: '01 March 2024',
    endDate: '31 August 2024',
    description: 'Learn the fundamentals of web development, from HTML/CSS to React and Node.js. This intensive bootcamp is designed to take you from zero to job-ready in six months.',
    careerOpportunities: 'Junior Web Developer, Frontend Developer, Backend Developer, QA Engineer.',
    skills: ['HTML/CSS', 'JavaScript', 'React', 'Node.js', 'Git'],
    capacity: 50,
    enrolledCount: 35,
    status: 'Open',
  ),
  const Programme(
    id: '2',
    title: 'Digital Marketing Specialist',
    provider: 'Marketing Pro',
    category: 'Marketing',
    level: 'Intermediate',
    duration: '3 Months',
    startDate: '15 April 2024',
    endDate: '15 July 2024',
    description: 'Master the art of digital marketing. Learn SEO, SEM, social media strategy, and content marketing to drive business growth in the digital age.',
    careerOpportunities: 'Social Media Manager, SEO Specialist, Digital Marketer, Content Strategist.',
    skills: ['SEO', 'SEM', 'Social Media', 'Content Strategy', 'Analytics'],
    capacity: 40,
    enrolledCount: 38,
    status: 'Open',
  ),
  const Programme(
    id: '3',
    title: 'Data Science Fundamentals',
    provider: 'Data Insights',
    category: 'Technology',
    level: 'Intermediate',
    duration: '4 Months',
    startDate: '01 May 2024',
    endDate: '31 August 2024',
    description: 'Dive into the world of data. Learn Python, SQL, and machine learning basics to turn data into actionable insights.',
    careerOpportunities: 'Data Analyst, Junior Data Scientist, Business Intelligence Analyst.',
    skills: ['Python', 'SQL', 'Statistics', 'Machine Learning', 'Pandas'],
    capacity: 30,
    enrolledCount: 30,
    status: 'Closed',
  ),
];

// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-004
// ═══════════════════════════════════════════════════════════════════════