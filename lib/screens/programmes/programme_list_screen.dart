import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/programmes/programme_detail_screen.dart';
import 'package:futurepath_employment_hub/core/widgets/notification_badge.dart';
import 'package:provider/provider.dart';
import 'package:futurepath_employment_hub/providers/search_filter_provider.dart';

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

// ───────────────────────────────────────────────────────────────────────
// MOCK DATA
// ───────────────────────────────────────────────────────────────────────
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
    description: "This 3-month programme covers user management, security configuration, data management, automation with Flow Builder, reports and dashboards, and AppExchange integration.",
    startDate: '15 Jul 2026',
    endDate: '15 Oct 2026',
    duration: '3 months',
    enrolledCount: 20,
    capacity: 25,
    skills: ['Salesforce', 'CRM', 'Data Management', 'Automation', 'Reports & Dashboards', 'Admin'],
    careerOpportunities: 'Completing this programme can qualify you for roles in business such as developer positions, analyst roles, and more.',
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
    careerOpportunities: 'Completing this programme can qualify you for roles such as marketing assistant and social media coordinator.',
    imageUrl: 'assets/images/programmes/digital_marketing.jpg',
  ),
];

const List<String> _locationFilters = ['All Locations', 'Cape Town', 'Johannesburg', 'Pretoria', 'Durban', 'Remote'];
const List<String> _programmeTypeFilters = ['All Types', 'Full-time', 'Part-time', 'Internship', 'Apprenticeship', 'Contract', 'Remote', 'Hybrid'];

// ───────────────────────────────────────────────────────────────────────
// SCREEN
// ───────────────────────────────────────────────────────────────────────
class ProgrammeListScreen extends StatefulWidget {
  final List<Programme> programmes;
  final void Function(Programme programme)? onProgrammeTap;
  final Future<void> Function()? onRefresh;

  const ProgrammeListScreen({
    super.key,
    this.programmes = mockProgrammes,
    this.onProgrammeTap,
    this.onRefresh,
  });

  @override
  State<ProgrammeListScreen> createState() => _ProgrammeListScreenState();
}

class _ProgrammeListScreenState extends State<ProgrammeListScreen> {
  static const List<String> _categories = [
    'All',
    'Technology',
    'Business',
    'Marketing',
    'Engineering',
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Programme> get _filteredProgrammes {
    final filterProvider = context.read<SearchFilterProvider>();

    return widget.programmes.where((programme) {
      final matchesCategory = _selectedCategory == 'All' || programme.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          programme.title.toLowerCase().contains(query) ||
          programme.description.toLowerCase().contains(query);

      // Apply location filter if any selected
      final matchesLocation = filterProvider.selectedLocations.isEmpty ||
          filterProvider.selectedLocations.contains(programme.provider);

      return matchesCategory && matchesSearch && matchesLocation;
    }).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer<SearchFilterProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Location Section
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _locationFilters.map((location) {
                      final isSelected = location == 'All Locations'
                          ? provider.selectedLocations.isEmpty
                          : provider.selectedLocations.contains(location);

                      return _FilterChip(
                        label: location,
                        selected: isSelected,
                        onTap: () {
                          provider.toggleLocation(location);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Programme Type Section
                  const Text(
                    'Programme Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _programmeTypeFilters.map((type) {
                      final isSelected = type == 'All Types'
                          ? provider.selectedLocations.isEmpty
                          : provider.selectedLocations.contains(type);

                      return _FilterChip(
                        label: type,
                        selected: isSelected,
                        onTap: () {
                          provider.toggleLocation(type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            provider.clearFilters();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white38),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    } else {
      await Future.delayed(const Duration(milliseconds: 600));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProgrammes;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Programmes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${filtered.length} programmes available',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.mutedText,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Consumer<SearchFilterProvider>(
                      builder: (context, provider, child) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.card,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: _showFilterBottomSheet,
                                icon: const Icon(Icons.tune, color: AppTheme.textDark, size: 24),
                              ),
                            ),
                            if (provider.activeFilterCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.accent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${provider.activeFilterCount}',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const NotificationBadge(iconColor: AppTheme.textDark),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search programmes...',
                hintStyle: const TextStyle(color: AppTheme.mutedText),
                prefixIcon: const Icon(Icons.search, color: AppTheme.mutedText),
                filled: true,
                fillColor: AppTheme.secondary,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategory = category),
                  selectedColor: AppTheme.accent,
                  backgroundColor: AppTheme.secondary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${filtered.length} programmes found',
              style: const TextStyle(
                color: AppTheme.mutedText,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppTheme.accent,
              child: filtered.isEmpty
                  ? ListView(
                children: const [
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      'No programmes match your search.',
                      style: TextStyle(color: AppTheme.mutedText),
                    ),
                  ),
                ],
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final programme = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProgrammeCard(
                      programme: programme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProgrammeDetailScreen(
                              programmeId: programme.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : Colors.white12,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.accent : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────
// REUSABLE CARD WIDGET
// ───────────────────────────────────────────────────────────────────────
class ProgrammeCard extends StatelessWidget {
  final Programme programme;
  final VoidCallback onTap;

  const ProgrammeCard({
    super.key,
    required this.programme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spotsLeft = programme.spotsRemaining;
    final progress = programme.capacity == 0 ? 0.0 : programme.enrolledCount / programme.capacity;

    return Material(
      color: AppTheme.card,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: AppTheme.secondary,
                    child: const Center(
                      child: Icon(Icons.image_outlined, size: 32, color: AppTheme.mutedText),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _StatusBadge(status: programme.status),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      programme.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    programme.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${programme.provider} · ${programme.duration} · ${programme.level}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    programme.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _InfoColumn(
                          label: 'Starts',
                          value: programme.startDate,
                        ),
                      ),
                      Expanded(
                        child: _InfoColumn(
                          label: 'Duration',
                          value: programme.duration,
                        ),
                      ),
                      Expanded(
                        child: _InfoColumn(
                          label: 'Spots left',
                          value: '$spotsLeft / ${programme.capacity}',
                          valueColor: spotsLeft <= 5 ? AppTheme.accent : AppTheme.textDark,
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
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoColumn({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.mutedText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status.toLowerCase() == 'open';
    final color = isOpen ? AppTheme.accent : AppTheme.mutedText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}