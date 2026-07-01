//Qaasim UIUX 022 SPRINT 2
// lib/screens/admin/admin_job_applications_screen.dart
// UIUX-022 — Admin Job Applications Screen
// No PII shown. Applicant ID, Qualification, and Status only.

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

enum ApplicationStatus { underReview, accepted, rejected }

extension ApplicationStatusLabel on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  Color get colour {
    switch (this) {
      case ApplicationStatus.underReview:
        return AppTheme.warning;
      case ApplicationStatus.accepted:
        return AppTheme.success;
      case ApplicationStatus.rejected:
        return AppTheme.error;
    }
  }

  Color get backgroundColour {
    switch (this) {
      case ApplicationStatus.underReview:
        return AppTheme.warning.withOpacity(0.1);
      case ApplicationStatus.accepted:
        return AppTheme.success.withOpacity(0.1);
      case ApplicationStatus.rejected:
        return AppTheme.error.withOpacity(0.1);
    }
  }

  IconData get icon {
    switch (this) {
      case ApplicationStatus.underReview:
        return Icons.schedule_rounded;
      case ApplicationStatus.accepted:
        return Icons.check_rounded;
      case ApplicationStatus.rejected:
        return Icons.close_rounded;
    }
  }
}

class JobApplication {
  final String applicationId;
  final String qualification;
  ApplicationStatus status;

  JobApplication({
    required this.applicationId,
    required this.qualification,
    required this.status,
  });
}

// ---------------------------------------------------------------------------
// Mock service — replace internals with Supabase calls in public_data_service.dart
// ---------------------------------------------------------------------------

class _MockApplicationService {
  Future<List<JobApplication>> getApplicationsForJob(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      JobApplication(
        applicationId: 'APP-0041',
        qualification: 'Matric / NSC',
        status: ApplicationStatus.underReview,
      ),
      JobApplication(
        applicationId: 'APP-0078',
        qualification: 'National Diploma (NQF 6)',
        status: ApplicationStatus.accepted,
      ),
      JobApplication(
        applicationId: 'APP-0093',
        qualification: 'Bachelor\'s Degree (NQF 7)',
        status: ApplicationStatus.underReview,
      ),
      JobApplication(
        applicationId: 'APP-0112',
        qualification: 'Matric / NSC',
        status: ApplicationStatus.rejected,
      ),
      JobApplication(
        applicationId: 'APP-0134',
        qualification: 'Higher Certificate (NQF 5)',
        status: ApplicationStatus.underReview,
      ),
      JobApplication(
        applicationId: 'APP-0157',
        qualification: 'National Diploma (NQF 6)',
        status: ApplicationStatus.accepted,
      ),
    ];
  }

  Future<void> updateApplicationStatus(
      String applicationId,
      ApplicationStatus newStatus,
      ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // [SUPABASE-HOOK] Replace with:
    // await supabase.from('applications')
    //   .update({'status': newStatus.label})
    //   .eq('application_id', applicationId);
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class AdminJobApplicationsScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;

  const AdminJobApplicationsScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  State<AdminJobApplicationsScreen> createState() =>
      _AdminJobApplicationsScreenState();
}

class _AdminJobApplicationsScreenState
    extends State<AdminJobApplicationsScreen> {
  final _service = _MockApplicationService();

  List<JobApplication> _all = [];
  List<JobApplication> _filtered = [];
  bool _loading = true;
  String? _error;

  ApplicationStatus? _activeFilter;
  final Set<String> _updating = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.getApplicationsForJob(widget.jobId);
      setState(() {
        _all = data;
        _applyFilter();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load applications. Pull down to retry.';
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    if (_activeFilter == null) {
      _filtered = List.from(_all);
    } else {
      _filtered = _all.where((a) => a.status == _activeFilter).toList();
    }
  }

  void _setFilter(ApplicationStatus? status) {
    setState(() {
      _activeFilter = status;
      _applyFilter();
    });
  }

  Future<void> _updateStatus(
      JobApplication application, ApplicationStatus newStatus) async {
    if (application.status == newStatus) return;

    setState(() => _updating.add(application.applicationId));

    try {
      await _service.updateApplicationStatus(
          application.applicationId, newStatus);
      setState(() {
        application.status = newStatus;
        _applyFilter();
        _updating.remove(application.applicationId);
      });
      if (mounted) _showStatusSnackbar(application.applicationId, newStatus);
    } catch (e) {
      setState(() => _updating.remove(application.applicationId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update ${application.applicationId}. Please try again.',
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showStatusSnackbar(String appId, ApplicationStatus status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(status.icon, color: status.colour, size: 14),
            const SizedBox(width: 8),
            Text(
              '$appId set to ${status.label}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: AppTheme.secondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openStatusSheet(JobApplication application) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Update Status',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                application.applicationId,
                style: const TextStyle(fontSize: 11, color: AppTheme.mutedText),
              ),
              const SizedBox(height: 16),
              ...ApplicationStatus.values.map((s) {
                final isCurrent = application.status == s;
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _updateStatus(application, s);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? s.backgroundColour
                          : AppTheme.secondary,
                      border: Border.all(
                        color: isCurrent
                            ? s.colour.withOpacity(0.3)
                            : AppTheme.secondary,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(s.icon, size: 16, color: s.colour),
                        const SizedBox(width: 10),
                        Text(
                          s.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isCurrent
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color:
                            isCurrent ? s.colour : AppTheme.textDark,
                          ),
                        ),
                        const Spacer(),
                        if (isCurrent)
                          Icon(Icons.check_rounded,
                              size: 16, color: s.colour),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  int _countFor(ApplicationStatus s) =>
      _all.where((a) => a.status == s).length;

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _loading
                  ? _buildLoading()
                  : _error != null
                  ? _buildError()
                  : _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Loading state
  // ---------------------------------------------------------------------------

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        color: AppTheme.primary,
        strokeWidth: 2,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top bar
  // ---------------------------------------------------------------------------

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border(
          bottom: BorderSide(color: AppTheme.secondary, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppTheme.card,
                border: Border.all(color: AppTheme.secondary, width: 0.5),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: AppTheme.mutedText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Applications',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  widget.jobTitle,
                  style:
                  const TextStyle(fontSize: 10, color: AppTheme.mutedText),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.2),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'ADMIN',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Error state
  // ---------------------------------------------------------------------------

  Widget _buildError() {
    return RefreshIndicator(
      onRefresh: _load,
      color: AppTheme.primary,
      backgroundColor: AppTheme.card,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      size: 40, color: AppTheme.subtleText),
                  const SizedBox(height: 14),
                  Text(
                    _error!,
                    style: TextStyle(
                        fontSize: 13, color: AppTheme.mutedText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: _load,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.2),
                            width: 0.5),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _load,
      color: AppTheme.primary,
      backgroundColor: AppTheme.card,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSummaryRow()),
          SliverToBoxAdapter(child: _buildFilterPills()),
          SliverToBoxAdapter(child: _buildResultCount()),
          if (_filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    _buildApplicationCard(_filtered[index]),
                childCount: _filtered.length,
              ),
            ),
          SliverToBoxAdapter(child: _buildPrivacyFooter()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Summary row
  // ---------------------------------------------------------------------------

  Widget _buildSummaryRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Row(
        children: [
          _summaryChip(
            label: 'Under Review',
            count: _countFor(ApplicationStatus.underReview),
            colour: AppTheme.warning,
            bg: AppTheme.warning.withOpacity(0.1),
          ),
          const SizedBox(width: 7),
          _summaryChip(
            label: 'Accepted',
            count: _countFor(ApplicationStatus.accepted),
            colour: AppTheme.success,
            bg: AppTheme.success.withOpacity(0.1),
          ),
          const SizedBox(width: 7),
          _summaryChip(
            label: 'Rejected',
            count: _countFor(ApplicationStatus.rejected),
            colour: AppTheme.error,
            bg: AppTheme.error.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _summaryChip({
    required String label,
    required int count,
    required Color colour,
    required Color bg,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(
              color: colour.withAlpha(64), width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colour,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                  fontSize: 9, color: colour.withAlpha(204)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Filter pills
  // ---------------------------------------------------------------------------

  Widget _buildFilterPills() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterPill(label: 'All', status: null),
            const SizedBox(width: 6),
            _filterPill(
                label: 'Under Review',
                status: ApplicationStatus.underReview),
            const SizedBox(width: 6),
            _filterPill(
                label: 'Accepted', status: ApplicationStatus.accepted),
            const SizedBox(width: 6),
            _filterPill(
                label: 'Rejected', status: ApplicationStatus.rejected),
          ],
        ),
      ),
    );
  }

  Widget _filterPill(
      {required String label, required ApplicationStatus? status}) {
    final isActive = _activeFilter == status;
    return GestureDetector(
      onTap: () => _setFilter(status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
          border: Border.all(
            color: isActive ? AppTheme.primary : AppTheme.secondary,
            width: isActive ? 1 : 0.5,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppTheme.mutedText,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Result count
  // ---------------------------------------------------------------------------

  Widget _buildResultCount() {
    final total = _all.length;
    final showing = _filtered.length;
    final label = _activeFilter == null
        ? '$total application${total == 1 ? '' : 's'}'
        : '$showing of $total · ${_activeFilter!.label}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: AppTheme.mutedText),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Application card
  // ---------------------------------------------------------------------------

  Widget _buildApplicationCard(JobApplication application) {
    final isUpdating = _updating.contains(application.applicationId);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.card,
          border: Border.all(color: AppTheme.secondary, width: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                        color: AppTheme.secondary, width: 0.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 18,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.applicationId,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        application.qualification,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(application, isUpdating),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
                color: AppTheme.secondary, height: 1, thickness: 0.5),
            const SizedBox(height: 10),
            Row(
              children: [
                _infoLabel(
                  icon: Icons.badge_outlined,
                  value: application.applicationId,
                  label: 'APPLICANT ID',
                ),
                const SizedBox(width: 16),
                _infoLabel(
                  icon: Icons.school_outlined,
                  value: application.qualification,
                  label: 'QUALIFICATION',
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: isUpdating ? null : () => _openStatusSheet(application),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  border:
                  Border.all(color: AppTheme.secondary, width: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isUpdating)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppTheme.mutedText,
                        ),
                      )
                    else
                      const Icon(Icons.swap_vert_rounded,
                          size: 14, color: AppTheme.mutedText),
                    const SizedBox(width: 6),
                    Text(
                      isUpdating ? 'Updating…' : 'Update Status',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isUpdating
                            ? AppTheme.mutedText.withOpacity(0.5)
                            : AppTheme.mutedText,
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

  Widget _buildStatusChip(JobApplication application, bool isUpdating) {
    final s = application.status;
    return GestureDetector(
      onTap: isUpdating ? null : () => _openStatusSheet(application),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: s.backgroundColour,
          border: Border.all(
              color: s.colour.withOpacity(0.3), width: 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUpdating)
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: s.colour,
                ),
              )
            else
              Icon(s.icon, size: 10, color: s.colour),
            const SizedBox(width: 4),
            Text(
              s.label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: s.colour,
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.expand_more_rounded, size: 10, color: s.colour),
          ],
        ),
      ),
    );
  }

  Widget _infoLabel({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              color: AppTheme.mutedText,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(icon, size: 11, color: AppTheme.mutedText),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty state
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
    final label = _activeFilter == null
        ? 'No applications yet'
        : 'No ${_activeFilter!.label.toLowerCase()} applications';
    final sub = _activeFilter == null
        ? 'Applications for this job will appear here once submitted.'
        : 'Try a different filter to see other applications.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined,
                size: 40, color: AppTheme.mutedText),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              style:
              const TextStyle(fontSize: 12, color: AppTheme.mutedText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Privacy footer
  // ---------------------------------------------------------------------------

  Widget _buildPrivacyFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border:
          Border(top: BorderSide(color: AppTheme.secondary, width: 0.5)),
        ),
        child: const Row(
          children: [
            Icon(Icons.lock_outline_rounded,
                size: 12, color: AppTheme.mutedText),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'No personal data is shown. Applicant names, emails, phone numbers, and ID documents are never accessible from this screen.',
                style: TextStyle(
                  fontSize: 9,
                  color: AppTheme.mutedText,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}