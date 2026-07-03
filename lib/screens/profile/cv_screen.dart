//cv_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/skill_chip.dart';
import '../../providers/user_profile_provider.dart';
import '../../models/programme.dart';

class CVScreen extends ConsumerWidget {
  const CVScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);

    return CvScreenContent(
      skills: userProfile.skills,
      completedProgrammes: userProfile.completedProgrammes,
      enrolledProgrammes: userProfile.enrolledProgrammes,
      onAddSkill: notifier.addSkill,
      onRemoveSkill: notifier.removeSkill,
      onUploadCV: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('CV upload coming soon!'),
            backgroundColor: AppTheme.accent,
          ),
        );
      },
    );
  }
}

class CvScreenContent extends StatefulWidget {
  final List<String> skills;
  final List<Programme> completedProgrammes;
  final List<Programme> enrolledProgrammes;
  final ValueChanged<String> onAddSkill;
  final ValueChanged<String> onRemoveSkill;
  final VoidCallback onUploadCV;

  const CvScreenContent({
    super.key,
    this.skills = const [],
    this.completedProgrammes = const [],
    this.enrolledProgrammes = const [],
    required this.onAddSkill,
    required this.onRemoveSkill,
    required this.onUploadCV,
  });

  @override
  State<CvScreenContent> createState() => _CvScreenContentState();
}

class _CvScreenContentState extends State<CvScreenContent> {
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
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: const Text(
                'FP',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 7),
            const Text(
              'CV & Skills',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.notifications_none,
                  color: AppTheme.mutedText,
                  size: 22,
                ),
              ),
              Positioned(
                top: 0,
                right: 14,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '2',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            height: 0.5,
            color: AppTheme.border,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [UIUX-PRIV-002] Privacy notice — personal data visible to authenticated user only
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.successLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0x332ECC8A),
                    width: 0.5,
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: AppTheme.mutedText,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your personal data is private and not shared with anyone.',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.mutedText,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CV Upload Section
            _buildSectionHeader('CV & Resume', trailing: null),
            _buildCVUploadSection(),

            // Skills Section
            _buildSectionHeader('Skills', trailing: GestureDetector(
              onTap: () {},
              child: const Text(
                '+ Add',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.primary,
                ),
              ),
            )),
            _buildSkillsSection(),

            // Programme History
            if (widget.enrolledProgrammes.isNotEmpty || widget.completedProgrammes.isNotEmpty)
              _buildProgrammeHistory()
            else
              _buildEmptyProgrammes(),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
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
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildCVUploadSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.surface3,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.cloud_upload_outlined,
              size: 24,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Upload your CV',
            style: TextStyle(
              color: AppTheme.textDark,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'PDF or DOC up to 5MB',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onUploadCV,
              icon: const Icon(Icons.upload_file, size: 16),
              label: const Text(
                'Choose File',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.skills.isNotEmpty)
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: widget.skills.map(
                    (skill) => SkillChip(
                  label: skill,
                  onRemove: () => widget.onRemoveSkill(skill),
                ),
              ).toList(),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No skills added yet',
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 11,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillController,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add a new skill',
                    hintStyle: const TextStyle(
                      color: AppTheme.subtleText,
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: AppTheme.surface2,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.border2,
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.border2,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppTheme.primary,
                        width: 1,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: _handleAddSkill,
                      icon: const Icon(
                        Icons.send,
                        color: AppTheme.primary,
                        size: 16,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _handleAddSkill(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProgrammes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 14),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 40,
              color: AppTheme.subtleText,
            ),
            const SizedBox(height: 10),
            const Text(
              'No programme history yet.',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgrammeHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.enrolledProgrammes.isNotEmpty) ...[
          _buildSectionHeader('Currently Enrolled', trailing: null),
          ...widget.enrolledProgrammes.map(
                (prog) => _buildProgrammeCard(prog, isEnrolled: true),
          ),
        ],
        if (widget.completedProgrammes.isNotEmpty) ...[
          _buildSectionHeader('Completed Programmes', trailing: null),
          ...widget.completedProgrammes.map(
                (prog) => _buildProgrammeCard(prog, isEnrolled: false),
          ),
        ],
      ],
    );
  }

  Widget _buildProgrammeCard(Programme prog, {required bool isEnrolled}) {
    final Color accentColor = isEnrolled ? AppTheme.primary : AppTheme.success;
    final Color accentLow = isEnrolled ? AppTheme.primaryLow : AppTheme.successLow;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
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
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accentLow,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: Icon(
              isEnrolled ? Icons.school_outlined : Icons.verified_outlined,
              color: accentColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        prog.name,
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: accentLow,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        isEnrolled ? 'Enrolled' : 'Completed',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  prog.status,
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 10,
                  ),
                ),
                if (prog.progress > 0) ...[
                  const SizedBox(height: 7),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.surface3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: prog.progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          color: AppTheme.subtleText,
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        '${(prog.progress * 100).round()}%',
                        style: const TextStyle(
                          color: AppTheme.subtleText,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (prog.isCompleted && prog.certificateUrl != null)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: AppTheme.primary,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }
}