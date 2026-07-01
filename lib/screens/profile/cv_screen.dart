import 'dart:async';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/cv_preview_utils.dart';
import '../../models/programme.dart';
import '../../models/user_profile.dart';
import '../../providers/user_profile_provider.dart';
import '../../core/widgets/skill_chip.dart';

class CVScreen extends ConsumerStatefulWidget {
  const CVScreen({super.key});

  @override
  ConsumerState<CVScreen> createState() => _CVScreenState();
}

class _CVScreenState extends ConsumerState<CVScreen> {
  // Web picker state must stay inside this State (NAV-006).
  String? _fileName;
  String? _previewUrl;
  Uint8List? _fileBytes;
  bool _isImage = false;

  html.FileUploadInputElement? _fileInput;
  html.Blob? _selectedBlob;

  String? get _fileExtLower {
    if (_fileName == null) return null;
    return _getExt(_fileName!);
  }

  String? _getExt(String fileName) {
    final parts = fileName.split('.');
    if (parts.isEmpty) return null;
    final ext = parts.last.trim().toLowerCase();
    return ext.isEmpty ? null : ext;
  }

  String _sanitizeCvFileName(String rawFileName) {
    final parts = rawFileName.split('.');
    if (parts.isEmpty) return rawFileName;

    final ext = parts.last.toLowerCase();
    final baseName = parts.length >= 2
        ? parts.sublist(0, parts.length - 1).join('.')
        : rawFileName;

    return '$baseName.$ext'
        .replaceAll(RegExp(r"\s\(\d+\)"), '')
        .replaceAll(RegExp(r"\s\(\d+\)$"), '');
  }

  bool _isAllowedExt(String extLower) {
    const allowed = {'pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'};
    return allowed.contains(extLower);
  }

  bool _isImageExt(String extLower) {
    const imageExt = {'png', 'jpg', 'jpeg'};
    return imageExt.contains(extLower);
  }

  @override
  void dispose() {
    _revokeObjectUrl();
    _fileInput?.remove();
    super.dispose();
  }

  void _revokeObjectUrl() {
    final url = _previewUrl;
    if (url == null) return;
    try {
      html.Url.revokeObjectUrl(url);
    } catch (_) {
      // ignore
    }
    _previewUrl = null;
  }

  // Web file picker.
  Future<void> _pickFileWeb() async {
    _fileInput ??= html.FileUploadInputElement();

    // Reset selection
    _fileInput!.value = '';
    _fileInput!.accept = '.pdf,.doc,.docx,.png,.jpg,.jpeg';

    final completer = Completer<void>();

    StreamSubscription<html.Event>? sub;
    sub = _fileInput!.onChange.listen((_) async {
      sub?.cancel();

      final files = _fileInput!.files;
      if (files == null || files.isEmpty) {
        completer.complete();
        return;
      }

      final file = files.first;
      final rawName = file.name ?? '';
      final ext = _getExt(rawName) ?? '';

      if (!_isAllowedExt(ext)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unsupported file type: .$ext'),
              backgroundColor: AppTheme.accent,
            ),
          );
        }
        completer.complete();
        return;
      }

      const maxBytes = 5 * 1024 * 1024;
      if (file.size > maxBytes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File too large. Max size is 5MB.'),
              backgroundColor: AppTheme.accent,
            ),
          );
        }
        completer.complete();
        return;
      }

      _revokeObjectUrl();
      _selectedBlob = file;
      _isImage = _isImageExt(ext);

      setState(() {
        _fileName = _sanitizeCvFileName(rawName);
        _fileBytes = null;
        _previewUrl = _isImage ? html.Url.createObjectUrlFromBlob(file) : null;
      });

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;

      final result = reader.result;
      if (result is ByteBuffer) {
        _fileBytes = Uint8List.view(result);
      }

      if (mounted) {
        setState(() {});
      }

      completer.complete();
    });

    _fileInput!.click();
    await completer.future;
  }

  Future<void> _persistSelectedCvToProfile() async {
    if (_fileName == null) return;

ref.read(userProfileProvider.notifier).updateCvFile(
      _fileName!,
      _fileBytes?.toList(growable: false),
      _selectedBlob,
    );







    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CV saved: ${_fileName!}'),
        backgroundColor: AppTheme.accent,
      ),
    );
  }

  Future<void> _previewCv() async {
    if (_fileName == null || _fileExtLower == null) return;

    final ext = _fileExtLower!;
    if (ext == 'doc' || ext == 'docx') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Preview not supported for DOC/DOCX. Please download instead.',
          ),
          backgroundColor: AppTheme.accent,
        ),
      );
      return;
    }

    final blob = _selectedBlob;
    if (blob == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file blob available for preview.'),
          backgroundColor: AppTheme.accent,
        ),
      );
      return;
    }

    final url = html.Url.createObjectUrlFromBlob(blob);
    try {
      html.window.open(url, '_blank');
    } finally {
      Future<void>.delayed(const Duration(seconds: 2), () {
        try {
          html.Url.revokeObjectUrl(url);
        } catch (_) {
          // ignore
        }
      });
    }
  }

  void _removeCv() {
    _revokeObjectUrl();
    _selectedBlob = null;

    setState(() {
      _fileName = null;
      _previewUrl = null;
      _fileBytes = null;
      _isImage = false;
    });

    ref.read(userProfileProvider.notifier).updateCvFile('', null, null);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CV removed'),
        backgroundColor: AppTheme.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    if (_fileName == null &&
        userProfile.cvFileName != null &&
        userProfile.cvFileName!.isNotEmpty) {
      _fileName = userProfile.cvFileName;
    }


    final List<String> skills = userProfile.skills;
    final List<Programme> completedProgrammes = userProfile.completedProgrammes;
    final List<Programme> enrolledProgrammes = userProfile.enrolledProgrammes;


    final bool hasSkills = skills.isNotEmpty;
    final bool hasProgrammes =
        enrolledProgrammes.isNotEmpty || completedProgrammes.isNotEmpty;

    final bool canSave = _fileName != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'CV & Resume',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textDark,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // When _fileName is not null, persist on-screen and show actions.
                    if (_fileName != null)
                      _buildSelectedFileSection()
                    else
                      _buildCVUploadSection(),
                    const SizedBox(height: 28),

                    // List rendering with fallbacks.
                    if (hasSkills)
                      _buildSkillsSection(skills)
                    else
                      _buildSkillsEmptyState(),

                    const SizedBox(height: 28),

                    if (hasProgrammes)
                      _buildProgrammeHistory(
                        completedProgrammes: completedProgrammes,
                        enrolledProgrammes: enrolledProgrammes,
                      )
                    else
                      _buildProgrammesEmptyState(),

                    // Space so content doesn't hide behind bottom button.
                    const SizedBox(height: 96),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canSave
                  ? () {
                          if (_fileName == null) return;
                          ref
                              .read(userProfileProvider.notifier)
                              .updateCvFile(
                                _fileName!,
                                _fileBytes?.toList(growable: false),
                                _selectedBlob,
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Changes saved successfully!',
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCVUploadSection() {
    return Container(
      key: const ValueKey('cv_upload_empty'),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary.withAlpha(51),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_upload_outlined,
              size: 40,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Upload your CV',
            style: TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'PDF/DOC/DOCX & images up to 5MB',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              await _pickFileWeb();

              // NAV-006: remove saveCvToProfile call; persist directly.
              await _persistSelectedCvToProfile();
            },
            icon: const Icon(Icons.upload_file, size: 20),
            label: const Text(
              'Choose File',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFileSection() {
    final extLower = _fileExtLower;
    final isImage = extLower != null && _isImageExt(extLower);

    // Custom file container showing document layout + actions.
    return Container(
      key: const ValueKey('cv_upload_selected'),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary.withAlpha(51),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isImage ? Icons.image_outlined : Icons.picture_as_pdf,
                  size: 40,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fileName ?? 'Selected CV',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      buildCvPreviewSummary(
                        _fileName,
                        _fileBytes?.lengthInBytes,
                      ),
                      style: TextStyle(
                        color: AppTheme.mutedText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isImage && _previewUrl != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primary.withAlpha(51),
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                _previewUrl!,
                fit: BoxFit.contain,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: _removeCv,
                child: Text(
                  'Remove CV',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _previewCv,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Preview CV'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Skills',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
            ),
            const Spacer(),
            const Text(
              '0',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'No skills added yet.',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SkillInput(
                onAddSkill: ref.read(userProfileProvider.notifier).addSkill,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsSection(List<String> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Skills',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
            ),
            const Spacer(),
            Text(
              '${skills.length}',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...skills.map(
              (skill) => SkillChip(
                label: skill,
                onRemove: () =>
                    ref.read(userProfileProvider.notifier).removeSkill(skill),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SkillInput(
                onAddSkill: ref.read(userProfileProvider.notifier).addSkill,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgrammeHistory({
    required List<Programme> completedProgrammes,
    required List<Programme> enrolledProgrammes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (enrolledProgrammes.isNotEmpty) ...[
          Row(
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 20,
                color: AppTheme.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'Currently Enrolled',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
              ),
              const Spacer(),
              Text(
                '${enrolledProgrammes.length}',
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...enrolledProgrammes.map(
            (prog) => _ProgrammeCard(prog, isEnrolled: true),
          ),
          const SizedBox(height: 20),
        ],
        if (completedProgrammes.isNotEmpty) ...[
          Row(
            children: [
              Icon(
                Icons.verified_outlined,
                size: 20,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                'Completed Programmes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
              ),
              const Spacer(),
              Text(
                '${completedProgrammes.length}',
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...completedProgrammes.map(
            (prog) => _ProgrammeCard(prog, isEnrolled: false),
          ),
        ],
      ],
    );
  }

  Widget _buildProgrammesEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 48,
              color: AppTheme.mutedText.withAlpha(128),
            ),
            const SizedBox(height: 12),
            const Text(
              'No programme history yet.',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillInput extends StatefulWidget {
  final ValueChanged<String> onAddSkill;

  const _SkillInput({required this.onAddSkill});

  @override
  State<_SkillInput> createState() => _SkillInputState();
}

class _SkillInputState extends State<_SkillInput> {
  final TextEditingController _skillController = TextEditingController();

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  void _handleAddSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty) {
      widget.onAddSkill(skill);
      _skillController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _skillController,
      decoration: InputDecoration(
        hintText: 'Add a new skill',
        hintStyle: TextStyle(color: AppTheme.mutedText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppTheme.primary.withAlpha(51),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppTheme.primary.withAlpha(51),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppTheme.accent,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: IconButton(
          onPressed: _handleAddSkill,
          icon: const Icon(
            Icons.send,
            color: AppTheme.accent,
          ),
        ),
      ),
      onSubmitted: (_) => _handleAddSkill(),
    );
  }
}

class _ProgrammeCard extends StatelessWidget {
  final Programme prog;
  final bool isEnrolled;

  const _ProgrammeCard(this.prog, {required this.isEnrolled});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isEnrolled
                  ? AppTheme.accent.withAlpha(26)
                  : Colors.green.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isEnrolled ? Icons.school_outlined : Icons.verified_outlined,
              color: isEnrolled ? AppTheme.accent : Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prog.name,
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  prog.status,
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                  ),
                ),
                if (prog.progress > 0) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: prog.progress,
                      backgroundColor: AppTheme.secondary,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isEnrolled ? AppTheme.accent : Colors.green,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(prog.progress * 100).round()}% complete',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (prog.isCompleted && prog.certificateUrl != null)
            const Icon(
              Icons.picture_as_pdf,
              color: Colors.red,
              size: 20,
            ),
        ],
      ),
    );
  }
}

