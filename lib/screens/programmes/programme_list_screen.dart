import 'package:flutter/material.dart';

import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import '../../services/sheets_service.dart';
import '../../core/widgets/loading_overlay.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';
import 'programme_detail_screen.dart';

/// ─────────────────────────────────────────────────────────────
/// DATA MODEL
/// ───────────────────────────────────────────────────────────
class Programme {
  final String id;
  final String title;
  final String provider;
  final String category;
  final String level;
  final String status;
  final String description;
  final String startDate;
  final String endDate;
  final String duration;
  final int enrolledCount;
  final int capacity;
  final List<String> skills;
  final String careerOpportunities;
  final String imageUrl;

  const Programme({
    required this.id,
    required this.title,
    required this.provider,
    required this.category,
    required this.level,
    required this.status,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.enrolledCount,
    required this.capacity,
    required this.skills,
    required this.careerOpportunities,
    required this.imageUrl,
  });

  int get spotsRemaining => capacity - enrolledCount;
}
// ═══════════════════════════════════════════════════════════════
// ADD THIS MOCK DATA HERE (after Programme class, before screen)
// ═══════════════════════════════════════════════════════════════
const List<Programme> mockProgrammes = [
  Programme(
    id: 'prog_001',
    title: 'Flutter Mobile Development',
    provider: 'TechNova Solutions',
    category: 'Technology',
    level: 'Beginner-Intermediate',
    status: 'Open',
    description: 'Build cross-platform mobile apps using Flutter & Dart for iOS and Android.',
    startDate: '01 Jul 2026',
    endDate: '01 Oct 2026',
    duration: '3 months',
    enrolledCount: 24,
    capacity: 30,
    skills: ['Flutter', 'Dart', 'Mobile UI', 'State Management'],
    careerOpportunities: 'Completing this programme can qualify you for roles such as mobile developer and app engineer.',
    imageUrl: 'assets/images/programmes/flutter_mobile.jpg',
  ),
  Programme(
    id: 'prog_002',
    title: 'Salesforce Administration',
    provider: 'FutureTech Africa',
    category: 'Business',
    level: 'Beginner',
    status: 'Open',
    description: 'This 3-month programme covers user management, security configuration, data management.',
    startDate: '15 Jul 2026',
    endDate: '15 Oct 2026',
    duration: '3 months',
    enrolledCount: 20,
    capacity: 25,
    skills: ['Salesforce', 'CRM', 'Data Management', 'Automation'],
    careerOpportunities: 'Completing this programme can qualify you for roles in business.',
    imageUrl: 'assets/images/programmes/salesforce_admin.jpg',
  ),
  Programme(
    id: 'prog_003',
    title: 'Digital Marketing Fundamentals',
    provider: 'GrowthLab Academy',
    category: 'Marketing',
    level: 'Beginner',
    status: 'Open',
    description: 'Learn SEO, social media marketing, content strategy and paid advertising fundamentals.',
    startDate: '10 Jul 2026',
    endDate: '10 Sep 2026',
    duration: '2 months',
    enrolledCount: 18,
    capacity: 20,
    skills: ['SEO', 'Social Media', 'Content Strategy', 'Google Ads'],
    careerOpportunities: 'Completing this programme can qualify you for roles such as marketing assistant.',
    imageUrl: 'assets/images/programmes/digital_marketing.jpg',
  ),
];

/// ─────────────────────────────────────────────────────────────
/// SCREEN
/// ─────────────────────────────────────────────────────────────
class ProgrammeListScreen extends StatefulWidget {
  const ProgrammeListScreen({super.key});

  @override
  State<ProgrammeListScreen> createState() =>
      _ProgrammeListScreenState();
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

  /// ─────────────────────────────────────────────────────────────
  /// DATA LOADING
  /// ─────────────────────────────────────────────────────────────
  /// ─────────────────────────────────────────────────────────────
  /// DATA LOADING
  /// ─────────────────────────────────────────────────────────────
  Future<void> loadProgrammes() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Use mock data directly
    programmes = mockProgrammes;
    lastUpdated = DateTime.now();

    setState(() {
      isLoading = false;
    });
  }
  Future<void> _handleRefresh() async {
    await loadProgrammes();
  }

  /// ─────────────────────────────────────────────────────────────
  /// FILTERING
  /// ─────────────────────────────────────────────────────────────
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

  /// ─────────────────────────────────────────────────────────────
  /// UI STATES
  /// ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: LoadingOverlay(),
      );
    }

    if (hasError) {
      return Scaffold(
        body: ErrorMessage(
          message: "Failed to load programmes",
          onRetry: loadProgrammes,
        ),
      );
    }

    if (programmes.isEmpty) {
      return const Scaffold(
        body: EmptyState(message: "No programmes found"),
      );
    }

    final filtered = _filteredProgrammes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Programmes"),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lastUpdated != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Last updated ${DateTime.now().difference(lastUpdated!).inMinutes} min ago",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) =>
                    setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search programmes...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppTheme.secondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            /// CATEGORY FILTERS
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category == _selectedCategory;

                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = category);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "${filtered.length} programmes found",
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 8),

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
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

/// ─────────────────────────────────────────────────────────────
/// PROGRAMME CARD
/// ─────────────────────────────────────────────────────────────
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              programme.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              "${programme.provider} • ${programme.level}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            Text(
              programme.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(value: progress),

            const SizedBox(height: 6),

            Text("Spots left: $spotsLeft"),
          ],
        ),
      ),
    );
  }
}