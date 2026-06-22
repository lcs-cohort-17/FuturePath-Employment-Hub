import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/core/widgets/skill_chip.dart';
import 'package:futurepath_employment_hub/screens/jobs/job_list_screen.dart'
    show Opportunity, RelatedProgramme;

class OpportunityDetailScreen extends StatefulWidget {
  /// [opportunity] — full opportunity object passed from the list screen.
  final Opportunity opportunity;

  /// [onApply] — override with real NAV-003 navigation when Application Form screen exists.
  final VoidCallback? onApply;

  const OpportunityDetailScreen({
    super.key,
    required this.opportunity,
    this.onApply,
  });

  @override
  State<OpportunityDetailScreen> createState() => _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState extends State<OpportunityDetailScreen> {
  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    // No async init needed currently; placeholder for INT-003 view tracking hook.
    super.initState();
  }

  @override
  void dispose() {
    // Placeholder for any future controllers (e.g. scroll analytics).
    super.dispose();
  }

  // ── Apply action ───────────────────────────────────────────────────────────
  void _handleApply() {
    if (widget.onApply != null) {
      widget.onApply!();
      return;
    }
    // Default: navigate to placeholder until NAV-003 wires the real form.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const _ApplicationFormPlaceholder(),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final opportunity = widget.opportunity;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(opportunity),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(opportunity),
                const SizedBox(height: 16),
                _buildMetaGrid(opportunity),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Position Overview',
                  child: Text(
                    opportunity.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textDark,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSection(
                  title: 'Required Skills',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: opportunity.skills.map((skill) => SkillChip(label: skill)).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                if (opportunity.relatedProgrammes.isNotEmpty)
                  _buildSection(
                    title: '💡 Prepare with These Programmes',
                    child: Column(
                      children: opportunity.relatedProgrammes
                          .map((programme) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ProgrammeCard(programme: programme),
                      ))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
          // ── Sticky Apply Now button ────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildApplyButton(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Opportunity opportunity) {
    return AppBar(
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: const Text(
        'Job Details',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.circle, size: 6, color: Color(0xFF16A34A)),
                SizedBox(width: 4),
                Text(
                  'Open',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(Opportunity opportunity) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: opportunity.logoColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              opportunity.logoInitials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opportunity.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                opportunity.company,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  opportunity.companyIndustry,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetaGrid(Opportunity opportunity) {
    // Build the detail chips for location, type, positions, salary, closing date, industry
    final items = <_MetaItem>[
      _MetaItem(
        icon: Icons.location_on_outlined,
        label: opportunity.location,
      ),
      _MetaItem(
        icon: Icons.access_time,
        label: opportunity.duration != null ? '${opportunity.jobType} (${opportunity.duration})' : opportunity.jobType,
      ),
      _MetaItem(
        icon: Icons.people_outline,
        label: '${opportunity.positions} ${opportunity.positions == 1 ? 'position' : 'positions'}',
      ),
      _MetaItem(
        icon: Icons.attach_money,
        label: '${opportunity.salaryRange}/month',
      ),
      _MetaItem(
        icon: Icons.calendar_today_outlined,
        label: 'Closes ${opportunity.closingDate}',
      ),
      _MetaItem(
        icon: Icons.business_outlined,
        label: opportunity.companyIndustry,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => _MetaChip(item: item)).toList(),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildApplyButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _handleApply,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Apply Now',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// META CHIP
// ---------------------------------------------------------------------------
class _MetaItem {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});
}

class _MetaChip extends StatelessWidget {
  final _MetaItem item;
  const _MetaChip({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.mutedText.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PROGRAMME CARD
// ---------------------------------------------------------------------------
class _ProgrammeCard extends StatelessWidget {
  final RelatedProgramme programme;
  const _ProgrammeCard({required this.programme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.mutedText.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          // Programme icon placeholder
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.school_outlined, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  programme.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${programme.duration} · ${programme.level}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (programme.isOpen)
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accent,
                side: const BorderSide(color: AppTheme.accent),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Open',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// APPLICATION FORM PLACEHOLDER — Replace with real screen from NAV-003
// ---------------------------------------------------------------------------
class _ApplicationFormPlaceholder extends StatelessWidget {
  const _ApplicationFormPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('Apply'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Application Form - coming soon',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.mutedText, fontSize: 16),
          ),
        ),
      ),
    );
  }
}