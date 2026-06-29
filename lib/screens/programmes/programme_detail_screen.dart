// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-004
// ═══════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/programmes/programme_list_screen.dart'
    show Programme;
import 'programme_application_screen.dart';

class ProgrammeDetailScreen extends StatelessWidget {
  final Programme programme;
  final void Function(Programme programme)? onApplyNow;
  final VoidCallback? onBack;

  const ProgrammeDetailScreen({
    super.key,
    required this.programme,
    this.onApplyNow,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final spotsLeft = programme.spotsRemaining;
    final progress = programme.capacity == 0
        ? 0.0
        : programme.enrolledCount / programme.capacity;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(
                  bottom: BorderSide(color: AppTheme.border, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Center(
                      child: Text(
                        'FP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Programme Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero image with category + status badges ──
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: AppTheme.surface3,
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 40,
                                color: AppTheme.subtleText,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 7,
                          left: 9,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              programme.category,
                              style: const TextStyle(
                                color: AppTheme.textDark,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 7,
                          right: 9,
                          child: _StatusBadge(status: programme.status),
                        ),
                      ],
                    ),

                    // ── Programme title + provider ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            programme.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            programme.provider,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Enrolment progress bar ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              minHeight: 3,
                              backgroundColor: AppTheme.surface3,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$spotsLeft spots left',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppTheme.subtleText,
                                ),
                              ),
                              Text(
                                '${programme.enrolledCount}/${programme.capacity}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppTheme.subtleText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Info grid ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _InfoTile(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'START DATE',
                                  value: programme.startDate,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _InfoTile(
                                  icon: Icons.event_outlined,
                                  label: 'END DATE',
                                  value: programme.endDate,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _InfoTile(
                                  icon: Icons.access_time,
                                  label: 'DURATION',
                                  value: programme.duration,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _InfoTile(
                                  icon: Icons.people_outline,
                                  label: 'CAPACITY',
                                  value:
                                  '${programme.enrolledCount}/${programme.capacity} enrolled',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _InfoTile(
                                  icon: Icons.military_tech_outlined,
                                  label: 'LEVEL',
                                  value: programme.level,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _InfoTile(
                                  icon: Icons.check_circle_outline,
                                  label: 'STATUS',
                                  value: programme.status,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Section: About This Programme ──
                    _SectionHeader(title: 'About This Programme'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppTheme.surface2,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppTheme.border, width: 0.5),
                        ),
                        child: Text(
                          programme.description,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.6,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ),
                    ),

                    // ── Section: Skills You'll Gain ──
                    _SectionHeader(title: "Skills You'll Gain"),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: programme.skills
                            .map((skill) => _SkillChip(label: skill))
                            .toList(),
                      ),
                    ),

                    // ── Section: Career Opportunities ──
                    _SectionHeader(title: 'Career Opportunities'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppTheme.surface2,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppTheme.border, width: 0.5),
                        ),
                        child: Text(
                          programme.careerOpportunities,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.6,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ),
                    ),

                    // ── Apply Now button ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (onApplyNow != null) {
                              onApplyNow!(programme);
                            } else {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) =>
                                    ProgrammeApplyScreen(programme: programme),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Apply Now'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────
// SECTION HEADER — red dot + title matching HTML .sec-h / .sec-t pattern
// ───────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────
// INFO TILE — matching HTML .scard grid cards
// ───────────────────────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppTheme.primary),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.subtleText,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────
// SKILL CHIP — matching HTML .tag style
// ───────────────────────────────────────────────────────────────────────
class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          color: AppTheme.mutedText,
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────
// STATUS BADGE — matching HTML .bopen / .bpend / .bsusp
// ───────────────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    final Color bgColor;
    final Color textColor;

    if (lower == 'open') {
      bgColor = AppTheme.successLow;
      textColor = AppTheme.success;
    } else if (lower == 'upcoming' || lower == 'starting soon') {
      bgColor = AppTheme.warningLow;
      textColor = AppTheme.warning;
    } else {
      bgColor = AppTheme.primaryLow;
      textColor = AppTheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '● $status',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-004
// ═══════════════════════════════════════════════════════════════════════