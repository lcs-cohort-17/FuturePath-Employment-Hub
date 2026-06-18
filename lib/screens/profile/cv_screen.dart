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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: Text(
          'CV & Resume',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CV Upload Section
            _buildCVUploadSection(),

            const SizedBox(height: 28),

            // Skills Section
            _buildSkillsSection(),

            const SizedBox(height: 28),

            // Programme History
            _buildProgrammeHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildCVUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.2),
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
            'PDF or DOC up to 5MB',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: widget.onUploadCV,
            icon: const Icon(Icons.upload_file, size: 20),
            label: const Text(
              'Choose File',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
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
              '${widget.skills.length}',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.skills.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...widget.skills.map(
                    (skill) => SkillChip(
                  label: skill,
                  onRemove: () => widget.onRemoveSkill(skill),
                ),
              ),
            ],
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No skills added yet',
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _skillController,
                decoration: InputDecoration(
                  hintText: 'Add a new skill',
                  hintStyle: TextStyle(color: AppTheme.mutedText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppTheme.primary.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppTheme.primary.withOpacity(0.2),
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
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgrammeHistory() {
    final hasProgrammes = widget.enrolledProgrammes.isNotEmpty ||
        widget.completedProgrammes.isNotEmpty;

    if (!hasProgrammes) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(
                Icons.school_outlined,
                size: 48,
                color: AppTheme.mutedText.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              Text(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.enrolledProgrammes.isNotEmpty) ...[
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
                '${widget.enrolledProgrammes.length}',
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.enrolledProgrammes.map(
                (prog) => _buildProgrammeCard(prog, isEnrolled: true),
          ),
          const SizedBox(height: 20),
        ],
        if (widget.completedProgrammes.isNotEmpty) ...[
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
                '${widget.completedProgrammes.length}',
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.completedProgrammes.map(
                (prog) => _buildProgrammeCard(prog, isEnrolled: false),
          ),
        ],
      ],
    );
  }

  Widget _buildProgrammeCard(Programme prog, {required bool isEnrolled}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  ? AppTheme.accent.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
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
                if (prog.progress != null) ...[
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
                    '${(prog.progress! * 100).round()}% complete',
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
            IconButton(
              onPressed: () {
              },
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}