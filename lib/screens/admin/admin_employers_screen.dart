import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/employer.dart';
import '../../services/employer_service.dart';
import '../admin/admin_employment_form_screen.dart';

class AdminEmployersScreen extends StatefulWidget {
  const AdminEmployersScreen({super.key});

  @override
  State<AdminEmployersScreen> createState() => _AdminEmployersScreenState();
}

class _AdminEmployersScreenState extends State<AdminEmployersScreen> {
  final EmployerService _service = EmployerService();
  final TextEditingController _searchController = TextEditingController();

  List<Employer> _employers = [];
  List<Employer> _filtered = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await _service.fetchEmployers();
      setState(() {
        _employers = results;
        _filtered = results;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.of(_employers)
          : _employers
          .where((e) =>
      e.companyName.toLowerCase().contains(q) ||
          e.industry.toLowerCase().contains(q) ||
          e.location.toLowerCase().contains(q))
          .toList();
    });
  }

  Future<void> _openAdd() async {
    final created = await Navigator.push<Employer>(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminEmployerFormScreen(),
      ),
    );
    if (created != null) {
      await _load();
    }
  }

  Future<void> _openEdit(Employer employer) async {
    final updated = await Navigator.push<Employer>(
      context,
      MaterialPageRoute(
        builder: (_) => AdminEmployerFormScreen(employer: employer),
      ),
    );
    if (updated != null) {
      await _load();
    }
  }

  Future<void> _confirmDelete(Employer employer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppTheme.border, width: 0.5),
        ),
        title: const Text(
          'Remove employer?',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          '${employer.companyName} will be permanently removed from the platform.',
          style: const TextStyle(
            color: AppTheme.mutedText,
            fontSize: 12,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.mutedText, fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Remove',
              style: TextStyle(
                color: AppTheme.error,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _service.deleteEmployer(employer.id);
        await _load();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${employer.companyName} removed.',
                style: const TextStyle(color: AppTheme.textDark, fontSize: 12),
              ),
              backgroundColor: AppTheme.surface3,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to remove employer: $e',
                style: const TextStyle(color: AppTheme.textDark, fontSize: 12),
              ),
              backgroundColor: AppTheme.errorLow,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: AppTheme.mutedText),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Employers',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppTheme.border),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.search_rounded,
                        size: 16, color: AppTheme.subtleText),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                          color: AppTheme.textDark, fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Search employers…',
                        hintStyle: TextStyle(
                            color: AppTheme.subtleText, fontSize: 12),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          size: 14, color: AppTheme.subtleText),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch();
                      },
                    ),
                ],
              ),
            ),
          ),

          // Count label
          if (!_loading && _error == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Text(
                '${_filtered.length} employer${_filtered.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    color: AppTheme.mutedText, fontSize: 10),
              ),
            ),

          // Body
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add_rounded, size: 22),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primary,
          strokeWidth: 2,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.errorLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.wifi_off_rounded,
                    color: AppTheme.error, size: 24),
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load employers',
                style: TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTheme.mutedText, fontSize: 11, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: _load,
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.surface3,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.business_outlined,
                    color: AppTheme.subtleText, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                _searchController.text.isNotEmpty
                    ? 'No employers match "${_searchController.text}"'
                    : 'No employers yet',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _searchController.text.isNotEmpty
                    ? 'Try a different search term.'
                    : 'Tap the + button to add the first employer.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppTheme.mutedText, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.primary,
      backgroundColor: AppTheme.surface2,
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 100),
        itemCount: _filtered.length,
        itemBuilder: (context, index) {
          final employer = _filtered[index];
          return _EmployerCard(
            employer: employer,
            onTap: () => _openEdit(employer),
            onLongPress: () => _confirmDelete(employer),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Employer Card
// ---------------------------------------------------------------------------

class _EmployerCard extends StatelessWidget {
  final Employer employer;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _EmployerCard({
    required this.employer,
    required this.onTap,
    required this.onLongPress,
  });

  /// Generates a consistent avatar colour from the company name.
  Color _avatarColor() {
    const colors = [
      AppTheme.infoLow,
      AppTheme.successLow,
      AppTheme.warningLow,
      AppTheme.primaryLow,
    ];
    return colors[employer.companyName.length % colors.length];
  }

  Color _avatarTextColor() {
    const colors = [
      AppTheme.info,
      AppTheme.success,
      AppTheme.warning,
      AppTheme.primary,
    ];
    return colors[employer.companyName.length % colors.length];
  }

  String get _initials {
    final parts = employer.companyName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return employer.companyName.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        padding: const EdgeInsets.all(13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _avatarColor(),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                _initials,
                style: TextStyle(
                  color: _avatarTextColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 11),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company name + hint
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          employer.companyName,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          size: 16, color: AppTheme.subtleText),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Industry
                  Row(
                    children: [
                      const Icon(Icons.work_outline_rounded,
                          size: 11, color: AppTheme.subtleText),
                      const SizedBox(width: 4),
                      Text(
                        employer.industry,
                        style: const TextStyle(
                          color: AppTheme.mutedText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 11, color: AppTheme.subtleText),
                      const SizedBox(width: 4),
                      Text(
                        employer.location,
                        style: const TextStyle(
                          color: AppTheme.mutedText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),

                  // Long-press hint
                  const SizedBox(height: 8),
                  const Text(
                    'Hold to remove',
                    style: TextStyle(
                      color: AppTheme.subtleText,
                      fontSize: 9,
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