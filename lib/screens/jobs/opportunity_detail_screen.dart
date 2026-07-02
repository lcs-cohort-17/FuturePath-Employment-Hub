// opportunity_detail_screen.dart
// Complete file with Apply modal, CV upload, consent, and real submission

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/models/opportunity.dart';
import 'package:futurepath_employment_hub/services/auth_services.dart';
import 'package:futurepath_employment_hub/services/job_application_service.dart';

// ─── Public entry point ────────────────────────────────────────────────────

class OpportunityDetailScreen extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityDetailScreen({
    super.key,
    required this.opportunity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildTopBar(context)),
                SliverToBoxAdapter(child: _buildHero()),
                SliverToBoxAdapter(child: _buildInfoGrid()),
                SliverToBoxAdapter(child: const _SectionHeader(label: 'About This Role')),
                SliverToBoxAdapter(child: _buildDescription()),
                SliverToBoxAdapter(child: const _SectionHeader(label: 'Skills Required')),
                SliverToBoxAdapter(child: _buildSkills()),
                if (opportunity.relatedProgrammes.isNotEmpty) ...[
                  SliverToBoxAdapter(
                      child: const _SectionHeader(label: 'Related Programmes')),
                  SliverToBoxAdapter(child: _buildRelatedProgrammes()),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            // Fixed bottom Apply button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildApplyBar(context),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 52,
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
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.mutedText,
                size: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              opportunity.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _StatusBadge(isOpen: opportunity.isOpen),
        ],
      ),
    );
  }

  // ── Hero block ────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: opportunity.logoColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              opportunity.logoInitials,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opportunity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  opportunity.company,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 11, color: AppTheme.subtleText),
                    const SizedBox(width: 3),
                    Text(
                      opportunity.location,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.subtleText,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.work_outline_rounded,
                        size: 11, color: AppTheme.subtleText),
                    const SizedBox(width: 3),
                    Text(
                      opportunity.jobType,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.subtleText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  opportunity.salaryRange,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Info grid ─────────────────────────────────────────────────────────────

  Widget _buildInfoGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'POSITION DETAILS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.mutedText,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    label: 'CLOSES',
                    value: opportunity.closingDate,
                  ),
                ),
                Expanded(
                  child: _InfoTile(
                    label: 'POSITIONS',
                    value: '${opportunity.positions} available',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    label: 'INDUSTRY',
                    value: opportunity.companyIndustry,
                  ),
                ),
                Expanded(
                  child: _InfoTile(
                    label: 'TYPE',
                    value: opportunity.jobType,
                  ),
                ),
              ],
            ),
            if (opportunity.duration != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      label: 'DURATION',
                      value: opportunity.duration!,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Description ───────────────────────────────────────────────────────────

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 9),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Text(
          opportunity.description,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.mutedText,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  // ── Skills ────────────────────────────────────────────────────────────────

  Widget _buildSkills() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 9),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: opportunity.skills
              .map((skill) => _SkillChip(label: skill))
              .toList(),
        ),
      ),
    );
  }

  // ── Related programmes ────────────────────────────────────────────────────

  Widget _buildRelatedProgrammes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 9),
      child: Column(
        children: opportunity.relatedProgrammes
            .map((prog) => _RelatedProgrammeCard(programme: prog))
            .toList(),
      ),
    );
  }

  // ── Apply bar ─────────────────────────────────────────────────────────────

  Widget _buildApplyBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border2, width: 0.5),
            ),
            child: const Icon(
              Icons.bookmark_border_rounded,
              color: AppTheme.mutedText,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: opportunity.isOpen
                    ? () => _showApplyModal(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  disabledBackgroundColor: AppTheme.surface3,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(
                  opportunity.isOpen ? 'Apply Now' : 'Closed',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Apply modal ───────────────────────────────────────────────────────────

  void _showApplyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ApplyModal(opportunity: opportunity),
    );
  }
}

// ─── Apply Modal (UPDATED with CV upload) ─────────────────────────────────

class _ApplyModal extends StatefulWidget {
  final Opportunity opportunity;

  const _ApplyModal({required this.opportunity});

  @override
  State<_ApplyModal> createState() => _ApplyModalState();
}

class _ApplyModalState extends State<_ApplyModal> {
  bool _privacyConsented = false;
  bool _isSubmitting = false;
  File? _cvFile;
  final _auth = AuthService();
  final _supabase = Supabase.instance.client;

  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _cvFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitApplication() async {
    if (_cvFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your CV (PDF format)'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (!_privacyConsented) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please consent to data processing'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Not logged in');

      // Get applicant ID from Applicant table
      final profile = await _supabase
          .from('Applicant')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      final applicantId = profile?['id'] as int?;
      if (applicantId == null) throw Exception('Applicant profile not found');

      // Upload CV to Supabase Storage
      final cvUrl = await JobApplicationService.uploadCv(_cvFile!, user.id);

      // Submit application to Job_Applications table
      await JobApplicationService.submitApplication(
        applicantId: applicantId,
        opportunityId: widget.opportunity.id,
        cvUrl: cvUrl,
        consentGiven: _privacyConsented,
      );

      if (mounted) {
        Navigator.of(context).pop();
        _showSuccessBanner(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 0.5),
          left: BorderSide(color: AppTheme.border, width: 0.5),
          right: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surface4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Modal title row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Apply for Position',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.opportunity.title,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppTheme.surface3,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border, width: 0.5),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppTheme.mutedText,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Company/role summary card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface3,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.opportunity.logoColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.opportunity.logoInitials,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.opportunity.company,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.opportunity.location} · ${widget.opportunity.jobType}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.opportunity.salaryRange,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // CV Upload
            const Text(
              'Upload CV (PDF only)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pickCV,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _cvFile != null ? AppTheme.success : AppTheme.border2,
                    width: _cvFile != null ? 1.5 : 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _cvFile != null ? Icons.file_present : Icons.upload_file,
                      color: _cvFile != null ? AppTheme.success : AppTheme.mutedText,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _cvFile != null
                          ? 'CV selected: ${_cvFile!.path.split('/').last}'
                          : 'Tap to select PDF',
                      style: TextStyle(
                        fontSize: 11,
                        color: _cvFile != null ? AppTheme.success : AppTheme.mutedText,
                        fontWeight: _cvFile != null ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Info notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.infoLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.info.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline_rounded,
                      size: 14, color: AppTheme.info),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your CV will be attached to this application. Make sure you upload the correct file before submitting.',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.info,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Cover letter field
            const Text(
              'Cover Letter (optional)',
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.mutedText,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border2, width: 0.5),
              ),
              child: const TextField(
                maxLines: 4,
                style: TextStyle(fontSize: 12, color: AppTheme.textDark),
                decoration: InputDecoration(
                  hintText:
                  'Tell the employer why you\'re a great fit for this role…',
                  hintStyle:
                  TextStyle(fontSize: 12, color: AppTheme.subtleText),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Privacy consent
            GestureDetector(
              onTap: () =>
                  setState(() => _privacyConsented = !_privacyConsented),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: _privacyConsented,
                      onChanged: (v) =>
                          setState(() => _privacyConsented = v ?? false),
                      activeColor: AppTheme.primary,
                      side: const BorderSide(
                          color: AppTheme.border2, width: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'I consent to my data being used for this job application. I understand my data is not shared externally beyond what is required to process this application.',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.mutedText,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: (_privacyConsented && !_isSubmitting)
                    ? _submitApplication
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  disabledBackgroundColor: AppTheme.surface3,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text('Submit Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.successLow,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: const [
            Icon(Icons.check_circle_outline_rounded,
                color: AppTheme.success, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Application submitted successfully!',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private widgets ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

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
            label,
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

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppTheme.subtleText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}

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

class _StatusBadge extends StatelessWidget {
  final bool isOpen;

  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isOpen ? AppTheme.successLow : AppTheme.surface3,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        isOpen ? '● Open' : '● Closed',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: isOpen ? AppTheme.success : AppTheme.mutedText,
        ),
      ),
    );
  }
}

class _RelatedProgrammeCard extends StatelessWidget {
  final RelatedProgramme programme;

  const _RelatedProgrammeCard({required this.programme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppTheme.primaryLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.book_outlined,
              size: 14,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  programme.title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${programme.duration} · ${programme.level}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: programme.isOpen ? AppTheme.successLow : AppTheme.warningLow,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              programme.isOpen ? '● Open' : '● Soon',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: programme.isOpen ? AppTheme.success : AppTheme.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}