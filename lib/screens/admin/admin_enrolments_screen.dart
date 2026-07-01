//UIUX-021 Onke? Sprint 2
// lib/screens/admin/admin_enrolments_screen.dart
// UIUX-021 — Admin Enrolment Management

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_message.dart';
import '../../core/widgets/empty_state.dart';

// ---------------------------------------------------------------------------
// Mock data model — replace with real model from models/enrolment.dart once
// the Supabase integration ticket lands.
// ---------------------------------------------------------------------------

enum EnrolmentStatus { pending, accepted, rejected }

class MockEnrolment {
  final String applicantId;
  final String qualification;
  EnrolmentStatus status;

  MockEnrolment({
    required this.applicantId,
    required this.qualification,
    required this.status,
  });
}

// ---------------------------------------------------------------------------
// Mock service — replace body with real PublicDataService calls once the
// Supabase integration ticket lands.
// ---------------------------------------------------------------------------

class _MockEnrolmentService {
  /// Returns a list of enrolments for a given programme ID.
  /// No PII is returned — applicant identity is represented by an opaque ID only.
  Future<List<MockEnrolment>> getEnrolmentsForProgramme(
      String programmeId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      MockEnrolment(
          applicantId: 'APL-00341',
          qualification: 'Matric / NSC',
          status: EnrolmentStatus.pending),
      MockEnrolment(
          applicantId: 'APL-00278',
          qualification: 'National Diploma',
          status: EnrolmentStatus.accepted),
      MockEnrolment(
          applicantId: 'APL-00512',
          qualification: 'Matric / NSC',
          status: EnrolmentStatus.pending),
      MockEnrolment(
          applicantId: 'APL-00189',
          qualification: "Bachelor's Degree",
          status: EnrolmentStatus.rejected),
      MockEnrolment(
          applicantId: 'APL-00634',
          qualification: 'National Certificate',
          status: EnrolmentStatus.pending),
      MockEnrolment(
          applicantId: 'APL-00407',
          qualification: 'National Diploma',
          status: EnrolmentStatus.accepted),
    ];
  }

  /// Persists a status update for a single enrolment.
  /// In production this will call Supabase with the applicant ID — never with PII.
  Future<void> updateEnrolmentStatus(
      String applicantId, EnrolmentStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // [SUPABASE-INTEGRATION] — Replace with:
    // await supabase.from('enrolments')
    //   .update({'status': newStatus.name})
    //   .eq('applicant_id_c', applicantId);
  }
}

// ---------------------------------------------------------------------------
// Filter enum used by the pill row
// ---------------------------------------------------------------------------

enum _EnrolmentFilter { all, pending, accepted, rejected }

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class AdminEnrolmentsScreen extends StatefulWidget {
  /// The opaque programme ID used to scope the enrolment query.
  final String programmeId;

  /// Human-readable programme name shown in the top bar and header.
  final String programmeName;

  const AdminEnrolmentsScreen({
    super.key,
    required this.programmeId,
    required this.programmeName,
  });

  @override
  State<AdminEnrolmentsScreen> createState() => _AdminEnrolmentsScreenState();
}

class _AdminEnrolmentsScreenState extends State<AdminEnrolmentsScreen> {
  final _service = _MockEnrolmentService();

  List<MockEnrolment> _allEnrolments = [];
  bool _loading = true;
  String? _error;
  _EnrolmentFilter _activeFilter = _EnrolmentFilter.all;

  // Tracks which applicant IDs currently have an in-flight status update.
  final Set<String> _updatingIds = {};

  @override
  void initState() {
    super.initState();
    _loadEnrolments();
  }

  Future<void> _loadEnrolments() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data =
          await _service.getEnrolmentsForProgramme(widget.programmeId);
      setState(() {
        _allEnrolments = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load enrolments. Please try again.';
        _loading = false;
      });
    }
  }

  List<MockEnrolment> get _filteredEnrolments {
    switch (_activeFilter) {
      case _EnrolmentFilter.all:
        return _allEnrolments;
      case _EnrolmentFilter.pending:
        return _allEnrolments
            .where((e) => e.status == EnrolmentStatus.pending)
            .toList();
      case _EnrolmentFilter.accepted:
        return _allEnrolments
            .where((e) => e.status == EnrolmentStatus.accepted)
            .toList();
      case _EnrolmentFilter.rejected:
        return _allEnrolments
            .where((e) => e.status == EnrolmentStatus.rejected)
            .toList();
    }
  }

  int _countFor(_EnrolmentFilter filter) {
    switch (filter) {
      case _EnrolmentFilter.all:
        return _allEnrolments.length;
      case _EnrolmentFilter.pending:
        return _allEnrolments
            .where((e) => e.status == EnrolmentStatus.pending)
            .length;
      case _EnrolmentFilter.accepted:
        return _allEnrolments
            .where((e) => e.status == EnrolmentStatus.accepted)
            .length;
      case _EnrolmentFilter.rejected:
        return _allEnrolments
            .where((e) => e.status == EnrolmentStatus.rejected)
            .length;
    }
  }

  Future<void> _updateStatus(
      MockEnrolment enrolment, EnrolmentStatus newStatus) async {
    if (_updatingIds.contains(enrolment.applicantId)) return;

    setState(() => _updatingIds.add(enrolment.applicantId));

    try {
      await _service.updateEnrolmentStatus(enrolment.applicantId, newStatus);
      setState(() {
        enrolment.status = newStatus;
        _updatingIds.remove(enrolment.applicantId);
      });
    } catch (_) {
      setState(() => _updatingIds.remove(enrolment.applicantId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update ${enrolment.applicantId}. Please try again.',
            style: const TextStyle(color: AppTheme.textDark, fontSize: 12),
          ),
          backgroundColor: AppTheme.surface3,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            Expanded(
              child: _loading
                  ? const Center(child: LoadingIndicator(color: AppTheme.primary))
                  : _error != null
                      ? Center(
                          child: ErrorMessage(
                            message: _error!,
                            onRetry: _loadEnrolments,
                          ),
                        )
                      : _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top bar — back arrow + programme name
  // ---------------------------------------------------------------------------

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.mutedText,
                size: 15,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Brand dot + screen title
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
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'Enrolments',
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Admin badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primaryLow,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'ADMIN',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body — programme header + filter pills + list
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    final filtered = _filteredEnrolments;

    return RefreshIndicator(
      onRefresh: _loadEnrolments,
      color: AppTheme.primary,
      backgroundColor: AppTheme.surface2,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildProgrammeHeader()),
          SliverToBoxAdapter(child: _buildFilterPills()),
          SliverToBoxAdapter(child: _buildResultCount(filtered.length)),
          SliverToBoxAdapter(child: _buildPrivacyBadge()),
          filtered.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: EmptyState(
                      message: _emptyMessage(),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildEnrolmentCard(filtered[index]),
                    childCount: filtered.length,
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Programme header card
  // ---------------------------------------------------------------------------

  Widget _buildProgrammeHeader() {
    final pendingCount = _countFor(_EnrolmentFilter.pending);
    final acceptedCount = _countFor(_EnrolmentFilter.accepted);
    final rejectedCount = _countFor(_EnrolmentFilter.rejected);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.infoLow,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Programme',
                  style: TextStyle(
                    color: AppTheme.info,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            widget.programmeName,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          // Mini stat row
          Row(
            children: [
              _miniStat(pendingCount.toString(), 'Pending',
                  AppTheme.warning, AppTheme.warningLow),
              const SizedBox(width: 8),
              _miniStat(acceptedCount.toString(), 'Accepted',
                  AppTheme.success, AppTheme.successLow),
              const SizedBox(width: 8),
              _miniStat(rejectedCount.toString(), 'Rejected',
                  AppTheme.primary, AppTheme.primaryLow),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
      String value, String label, Color valueColor, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.mutedText,
                fontSize: 10,
              ),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: Row(
        children: [
          _filterPill(_EnrolmentFilter.all, 'All'),
          const SizedBox(width: 6),
          _filterPill(_EnrolmentFilter.pending, 'Pending'),
          const SizedBox(width: 6),
          _filterPill(_EnrolmentFilter.accepted, 'Accepted'),
          const SizedBox(width: 6),
          _filterPill(_EnrolmentFilter.rejected, 'Rejected'),
        ],
      ),
    );
  }

  Widget _filterPill(_EnrolmentFilter filter, String label) {
    final isActive = _activeFilter == filter;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? AppTheme.primary : AppTheme.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppTheme.subtleText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Result count line
  // ---------------------------------------------------------------------------

  Widget _buildResultCount(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      child: Text(
        '$count enrolment${count == 1 ? '' : 's'}',
        style: const TextStyle(color: AppTheme.mutedText, fontSize: 10),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Privacy badge — always visible to reinforce no-PII guarantee
  // ---------------------------------------------------------------------------

  Widget _buildPrivacyBadge() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 2, 14, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.infoLow,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: AppTheme.info.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.lock_outline_rounded,
              color: AppTheme.info, size: 13),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'Applicant names, emails, and IDs are never shown. '
              'Only the anonymised Applicant Reference is displayed.',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Enrolment card
  // ---------------------------------------------------------------------------

  Widget _buildEnrolmentCard(MockEnrolment enrolment) {
    final isUpdating = _updatingIds.contains(enrolment.applicantId);
    final isPending = enrolment.status == EnrolmentStatus.pending;
    final isAccepted = enrolment.status == EnrolmentStatus.accepted;
    final isRejected = enrolment.status == EnrolmentStatus.rejected;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row — applicant ID + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar placeholder — initials derived from ID only
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.surface3,
                      borderRadius: BorderRadius.circular(9),
                      border:
                          Border.all(color: AppTheme.border2, width: 0.5),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: AppTheme.subtleText,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enrolment.applicantId,
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        enrolment.qualification,
                        style: const TextStyle(
                          color: AppTheme.mutedText,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _statusBadge(enrolment.status),
            ],
          ),

          // Action buttons — only shown while pending; collapsed once decided
          if (isPending) ...[
            const SizedBox(height: 10),
            isUpdating
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          label: 'Accept',
                          icon: Icons.check_rounded,
                          bgColor: AppTheme.successLow,
                          borderColor:
                              AppTheme.success.withValues(alpha: 0.3),
                          textColor: AppTheme.success,
                          onTap: () => _updateStatus(
                              enrolment, EnrolmentStatus.accepted),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _actionButton(
                          label: 'Reject',
                          icon: Icons.close_rounded,
                          bgColor: AppTheme.errorLow,
                          borderColor:
                              AppTheme.error.withValues(alpha: 0.3),
                          textColor: AppTheme.error,
                          onTap: () => _updateStatus(
                              enrolment, EnrolmentStatus.rejected),
                        ),
                      ),
                    ],
                  ),
          ],

          // Resolved state footer
          if (isAccepted || isRejected) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isAccepted
                    ? AppTheme.successLow
                    : AppTheme.errorLow,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAccepted
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    color: isAccepted ? AppTheme.success : AppTheme.error,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isAccepted
                        ? 'Enrolment accepted'
                        : 'Enrolment rejected',
                    style: TextStyle(
                      color: isAccepted ? AppTheme.success : AppTheme.error,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Status badge
  // ---------------------------------------------------------------------------

  Widget _statusBadge(EnrolmentStatus status) {
    switch (status) {
      case EnrolmentStatus.pending:
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.warningLow,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            '● Pending',
            style: TextStyle(
              color: AppTheme.warning,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      case EnrolmentStatus.accepted:
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.successLow,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            '● Accepted',
            style: TextStyle(
              color: AppTheme.success,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      case EnrolmentStatus.rejected:
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.errorLow,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            '● Rejected',
            style: TextStyle(
              color: AppTheme.error,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Accept / Reject button
  // ---------------------------------------------------------------------------

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 13),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty state message per filter
  // ---------------------------------------------------------------------------

  String _emptyMessage() {
    switch (_activeFilter) {
      case _EnrolmentFilter.all:
        return 'No enrolments yet for this programme.';
      case _EnrolmentFilter.pending:
        return 'No pending enrolments. All caught up.';
      case _EnrolmentFilter.accepted:
        return 'No accepted enrolments yet.';
      case _EnrolmentFilter.rejected:
        return 'No rejected enrolments.';
    }
  }
}