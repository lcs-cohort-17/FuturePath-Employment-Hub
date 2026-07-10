// lib/screens/jobs/staff_job_detail_screen.dart
// Detail screen for StaffJobModel with Apply functionality

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../models/staff_job_model.dart';
import '../../services/auth_services.dart';
import '../../services/job_application_service.dart';

class StaffJobDetailScreen extends StatefulWidget {
  final StaffJobModel job;
  const StaffJobDetailScreen({super.key, required this.job});

  @override
  State<StaffJobDetailScreen> createState() => _StaffJobDetailScreenState();
}

class _StaffJobDetailScreenState extends State<StaffJobDetailScreen> {
  final AuthService _auth = AuthService();

  bool get _isOpen => widget.job.opportunityStatus.toLowerCase() == 'open';

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          job.positionTitle,
          style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w700, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isOpen ? AppTheme.primary : AppTheme.surface3,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              _isOpen ? '● Apply' : '● Closed',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _isOpen ? Colors.white : AppTheme.mutedText,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: AppTheme.border, height: 0.5),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.positionTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                const SizedBox(height: 4),
                Text('Employer ID: ${job.employerId ?? 'N/A'}', style: const TextStyle(fontSize: 13, color: AppTheme.mutedText)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(color: AppTheme.surface2, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border, width: 0.5)),
                  child: Column(
                    children: [
                      _infoRow('Positions', '${job.numberAvailablePositions ?? 'N/A'}'),
                      _infoRow('Closing Date', job.closingDate != null ? '${job.closingDate!.day}/${job.closingDate!.month}/${job.closingDate!.year}' : 'N/A'),
                      _infoRow('Status', job.opportunityStatus),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (job.positionDescription != null && job.positionDescription!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Description', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                      const SizedBox(height: 8),
                      Text(job.positionDescription!, style: const TextStyle(fontSize: 12, color: AppTheme.mutedText, height: 1.6)),
                    ],
                  ),
                const SizedBox(height: 16),
                if (job.requiredSkills != null && job.requiredSkills!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Skills', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: job.requiredSkills!.map((skill) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.surface2, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.border, width: 0.5)),
                          child: Text(skill, style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
                        )).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildApplyBar(context),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
      ],
    ),
  );

  Widget _buildApplyBar(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: const BoxDecoration(
      color: AppTheme.surface,
      border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
    ),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isOpen ? () => _showApplyModal(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          disabledBackgroundColor: AppTheme.surface3,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        child: Text(_isOpen ? 'Apply Now' : 'Closed'),
      ),
    ),
  );

  void _showApplyModal(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _StaffJobApplyModal(job: widget.job),
  );
}

// ─── Apply Modal ─────────────────────────────────────────────────────────────

class _StaffJobApplyModal extends StatefulWidget {
  final StaffJobModel job;
  const _StaffJobApplyModal({required this.job});

  @override
  State<_StaffJobApplyModal> createState() => _StaffJobApplyModalState();
}

class _StaffJobApplyModalState extends State<_StaffJobApplyModal> {
  bool _privacyConsented = false;
  bool _isSubmitting = false;

  // CV (required)
  File? _cvFile;
  Uint8List? _cvBytes;
  String? _cvFileName;

  // Motivational Letter (optional)
  File? _motivationalLetterFile;
  Uint8List? _motivationalLetterBytes;
  String? _motivationalLetterFileName;

  final _auth = AuthService();
  final _supabase = Supabase.instance.client;

  // ─── Pick CV ──────────────────────────────────────────────────────────────

  Future<void> _pickCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        _cvFileName = file.name;
        if (kIsWeb) {
          _cvBytes = file.bytes;
          _cvFile = null;
        } else {
          _cvFile = File(file.path!);
          _cvBytes = null;
        }
      });
    }
  }

  // ─── Pick Motivational Letter ──────────────────────────────────────────

  Future<void> _pickMotivationalLetter() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null) {
      final file = result.files.single;
      setState(() {
        _motivationalLetterFileName = file.name;
        if (kIsWeb) {
          _motivationalLetterBytes = file.bytes;
          _motivationalLetterFile = null;
        } else {
          _motivationalLetterFile = File(file.path!);
          _motivationalLetterBytes = null;
        }
      });
    }
  }

  // ─── Submit ──────────────────────────────────────────────────────────────

  Future<void> _submitApplication() async {
    // CV required
    if (_cvFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your CV (PDF format)'), backgroundColor: Colors.orange),
      );
      return;
    }
    if (!_privacyConsented) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please consent to data processing'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('Not logged in');

      final profile = await _supabase
          .from('Applicant')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();
      final applicantId = profile?['id'] as int?;
      if (applicantId == null) throw Exception('Applicant profile not found');

      // Upload CV
      String cvUrl;
      if (kIsWeb) {
        if (_cvBytes == null) throw Exception('CV bytes not available');
        cvUrl = await JobApplicationService.uploadCvFromBytes(_cvBytes!, user.id, _cvFileName!);
      } else {
        if (_cvFile == null) throw Exception('CV file not available');
        cvUrl = await JobApplicationService.uploadCv(_cvFile!, user.id);
      }

      // Upload motivational letter (optional)
      String? motivationalLetterUrl;
      if (_motivationalLetterFileName != null) {
        if (kIsWeb) {
          if (_motivationalLetterBytes == null) throw Exception('Motivational letter bytes not available');
          motivationalLetterUrl = await JobApplicationService.uploadMotivationalLetterFromBytes(
            _motivationalLetterBytes!,
            user.id,
            _motivationalLetterFileName!,
          );
        } else {
          if (_motivationalLetterFile == null) throw Exception('Motivational letter file not available');
          motivationalLetterUrl = await JobApplicationService.uploadMotivationalLetter(
            _motivationalLetterFile!,
            user.id,
          );
        }
      }

      // Submit application
      await JobApplicationService.submitApplication(
        applicantId: applicantId,
        opportunityId: widget.job.opportunityId,
        cvUrl: cvUrl,
        motivationalLetterUrl: motivationalLetterUrl,
        consentGiven: _privacyConsented,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Apply for Position', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                      const SizedBox(height: 2),
                      Text(widget.job.positionTitle, style: const TextStyle(fontSize: 11, color: AppTheme.mutedText)),
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
                    child: const Icon(Icons.close_rounded, color: AppTheme.mutedText, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ─── CV Upload (Required) ────────────────────────────────────

            const Text('Upload CV (PDF only)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
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
                    color: _cvFileName != null ? AppTheme.success : AppTheme.border2,
                    width: _cvFileName != null ? 1.5 : 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(_cvFileName != null ? Icons.file_present : Icons.upload_file,
                        color: _cvFileName != null ? AppTheme.success : AppTheme.mutedText, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      _cvFileName != null ? 'CV selected: $_cvFileName' : 'Tap to select PDF (required)',
                      style: TextStyle(
                        fontSize: 11,
                        color: _cvFileName != null ? AppTheme.success : AppTheme.mutedText,
                        fontWeight: _cvFileName != null ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ─── Motivational Letter Upload (Optional) ──────────────────

            const Text('Motivational Letter (optional)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pickMotivationalLetter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _motivationalLetterFileName != null ? AppTheme.success : AppTheme.border2,
                    width: _motivationalLetterFileName != null ? 1.5 : 0.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(_motivationalLetterFileName != null ? Icons.file_present : Icons.upload_file,
                        color: _motivationalLetterFileName != null ? AppTheme.success : AppTheme.mutedText, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      _motivationalLetterFileName != null
                          ? 'Letter: ${_motivationalLetterFileName}'
                          : 'Tap to select PDF (optional)',
                      style: TextStyle(
                        fontSize: 11,
                        color: _motivationalLetterFileName != null ? AppTheme.success : AppTheme.mutedText,
                        fontWeight: _motivationalLetterFileName != null ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ─── Privacy Policy ──────────────────────────────────────────

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface3,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.border.withOpacity(0.3), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.privacy_tip_outlined, size: 14, color: AppTheme.primary),
                      const SizedBox(width: 6),
                      const Text('Privacy Policy', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your personal data (name, email, CV, and motivational letter) will be shared only with the employer for this specific job application. Your data will not be used for any other purpose and will be deleted after the hiring process is complete. By submitting this application, you consent to this data processing.',
                    style: TextStyle(fontSize: 10, color: AppTheme.mutedText, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ─── Privacy Consent ──────────────────────────────────────────

            GestureDetector(
              onTap: () => setState(() => _privacyConsented = !_privacyConsented),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: _privacyConsented,
                      onChanged: (v) => setState(() => _privacyConsented = v ?? false),
                      activeColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.border2, width: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'I have read and consent to the data processing described above.',
                      style: TextStyle(fontSize: 10, color: AppTheme.mutedText, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─── Submit Button ────────────────────────────────────────────

            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: (_privacyConsented && !_isSubmitting) ? _submitApplication : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  disabledBackgroundColor: AppTheme.surface3,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                child: _isSubmitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Submit Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}