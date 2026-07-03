// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-012
// ═══════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/models/programme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_services.dart';
import '../../services/public_data_service.dart';
import 'my_programmes_screen.dart'; // same folder

// ───────────────────────────────────────────────────────────────────────
// MODELS
// ───────────────────────────────────────────────────────────────────────

class ApplicantProfile {
  final String fullName;
  final String saIdNumber;
  final String email;
  final String phone;
  final String? cvFileName;

  const ApplicantProfile({
    required this.fullName,
    required this.saIdNumber,
    required this.email,
    required this.phone,
    this.cvFileName,
  });
}

const ApplicantProfile mockApplicantProfile = ApplicantProfile(
  fullName: 'Sipho Dlamini',
  saIdNumber: '0001015800083',
  email: 'sipho.dlamini@gmail.com',
  phone: '071 234 5678',
  cvFileName: null,
);

enum ProgrammeApplicationStatus { pending, accepted, completed }

class ProgrammeApplicationData {
  final String programmeId;
  final String fullName;
  final String saIdNumber;
  final String email;
  final String phone;
  final String? cvFileName;
  final String? motivationStatement;
  final String? previousExperience;
  final ProgrammeApplicationStatus status;

  const ProgrammeApplicationData({
    required this.programmeId,
    required this.fullName,
    required this.saIdNumber,
    required this.email,
    required this.phone,
    this.cvFileName,
    this.motivationStatement,
    this.previousExperience,
    this.status = ProgrammeApplicationStatus.pending,
  });

  Map<String, dynamic> toJson() => {
    'type': 'programme',
    'programmeId': programmeId,
    'fullName': fullName,
    'saIdNumber': saIdNumber,
    'email': email,
    'phone': phone,
    'cvFileName': cvFileName,
    'motivationStatement': motivationStatement,
    'previousExperience': previousExperience,
    'status': status.name,
  };
}

class ApplicationResult {
  final bool success;
  final String? errorMessage;

  const ApplicationResult.ok() : success = true, errorMessage = null;
  const ApplicationResult.failure(this.errorMessage) : success = false;
}

// ───────────────────────────────────────────────────────────────────────
// SCREEN
// ───────────────────────────────────────────────────────────────────────
class ProgrammeApplyScreen extends StatefulWidget {
  final Programme programme;
  final ApplicantProfile applicantProfile;
  final Future<ApplicationResult> Function(ProgrammeApplicationData data)?
  onSubmit;
  final void Function(ProgrammeApplicationData data)? onSuccess;
  final VoidCallback? onClose;

  const ProgrammeApplyScreen({
    super.key,
    required this.programme,
    this.applicantProfile = mockApplicantProfile,
    this.onSubmit,
    this.onSuccess,
    this.onClose,
  });

  @override
  State<ProgrammeApplyScreen> createState() => _ProgrammeApplyScreenState();
}

class _ProgrammeApplyScreenState extends State<ProgrammeApplyScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _saIdController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _motivationController;
  late TextEditingController _experienceController;

  String? _cvFileName;
  bool _isSubmitting = false;
  bool _privacyConsentGiven = false;

  static const int _motivationMaxLength = 500;

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.applicantProfile.fullName);
    _saIdController =
        TextEditingController(text: widget.applicantProfile.saIdNumber);
    _emailController =
        TextEditingController(text: widget.applicantProfile.email);
    _phoneController =
        TextEditingController(text: widget.applicantProfile.phone);
    _motivationController = TextEditingController();
    _experienceController = TextEditingController();
    _cvFileName = widget.applicantProfile.cvFileName;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _saIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _motivationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _handleUploadCv() async {
    setState(() => _cvFileName = 'my_cv.pdf');
  }

  // ─── REAL SUBMISSION ──────────────────────────────────────────────────

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_privacyConsentGiven) {
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
      // 1. Get current user
      final user = AuthService().currentUser;
      if (user == null) throw Exception('Not logged in');

      // 2. Get applicant ID from Applicant table
      final supabase = Supabase.instance.client;
      final profile = await supabase
          .from('Applicant')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();
      final applicantId = profile?['id'] as int?;
      if (applicantId == null) throw Exception('Applicant profile not found');

      // 3. Build application data
      final data = ProgrammeApplicationData(
        programmeId: widget.programme.id,
        fullName: _fullNameController.text.trim(),
        saIdNumber: _saIdController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        cvFileName: _cvFileName,
        motivationStatement: _motivationController.text.trim().isEmpty
            ? null
            : _motivationController.text.trim(),
        previousExperience: _experienceController.text.trim().isEmpty
            ? null
            : _experienceController.text.trim(),
        status: ProgrammeApplicationStatus.pending,
      );

      // 4. Either use custom submit (if provided) or default database insert
      if (widget.onSubmit != null) {
        final result = await widget.onSubmit!(data);
        if (!result.success) {
          throw Exception(result.errorMessage ?? 'Submission failed');
        }
      } else {
        // Default: insert into Programme_Enrolments
        await PublicDataService.enrolInProgramme(
          applicantId: applicantId,
          programmeId: widget.programme.id,
          status: 'pending',
        );
      }

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      // 5. Success – show success screen
      if (widget.onSuccess != null) {
        widget.onSuccess!(data);
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProgrammeApplicationSuccessScreen(
              programme: widget.programme,
              applicationData: data,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (the UI remains exactly as before, unchanged) ...
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.92,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.surface3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Enrol in Programme',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.programme.title,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onClose ?? () => Navigator.of(context).pop(),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.surface3,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: AppTheme.mutedText,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 0.5, color: AppTheme.border),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLow,
                              border: Border.all(
                                color: AppTheme.primary.withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Text('✨', style: TextStyle(fontSize: 13)),
                                SizedBox(width: 7),
                                Text(
                                  'Details auto-filled from your profile',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          const _FieldLabel(
                            icon: Icons.person_outline,
                            label: 'Full Name',
                            required: true,
                          ),
                          const SizedBox(height: 4),
                          _AppTextField(
                            controller: _fullNameController,
                            validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Full name is required'
                                : null,
                          ),
                          const SizedBox(height: 10),

                          const _FieldLabel(
                            icon: Icons.tag,
                            label: 'SA ID Number',
                            required: true,
                          ),
                          const SizedBox(height: 4),
                          _AppTextField(
                            controller: _saIdController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final trimmed = value?.trim() ?? '';
                              if (trimmed.isEmpty) {
                                return 'SA ID number is required';
                              }
                              if (trimmed.length != 13) {
                                return 'SA ID number must be 13 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel(label: 'Email'),
                                    const SizedBox(height: 4),
                                    _AppTextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        final trimmed = value?.trim() ?? '';
                                        if (trimmed.isEmpty) {
                                          return 'Required';
                                        }
                                        if (!trimmed.contains('@')) {
                                          return 'Invalid email';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel(label: 'Phone'),
                                    const SizedBox(height: 4),
                                    _AppTextField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      validator: (value) =>
                                      (value == null || value.trim().isEmpty)
                                          ? 'Required'
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          const _FieldLabel(
                            icon: Icons.description_outlined,
                            label: 'CV / Resume',
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: _handleUploadCv,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: AppTheme.surface3,
                                border: Border.all(
                                  color: AppTheme.border2,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _cvFileName != null
                                        ? Icons.check_circle_outline
                                        : Icons.upload_outlined,
                                    color: _cvFileName != null
                                        ? AppTheme.success
                                        : AppTheme.primary,
                                    size: 22,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _cvFileName ?? 'Upload CV (PDF, DOC)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _cvFileName != null
                                          ? AppTheme.success
                                          : AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_cvFileName == null) ...[
                            const SizedBox(height: 5),
                            const Text(
                              'Add your CV to your profile to auto-fill this field',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.mutedText,
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),

                          const _FieldLabel(label: 'Cover Letter (Optional)'),
                          const SizedBox(height: 4),
                          _AppTextField(
                            controller: _motivationController,
                            maxLines: 4,
                            maxLength: _motivationMaxLength,
                            hintText:
                            "Tell us why you're a great fit for ${widget.programme.title}...",
                            buildCounter: (
                                context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) =>
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    '$currentLength/$maxLength',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.mutedText,
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 10),

                          const _FieldLabel(
                              label: 'Previous Experience (Optional)'),
                          const SizedBox(height: 4),
                          _AppTextField(
                            controller: _experienceController,
                            maxLines: 3,
                            hintText: 'Share any relevant prior experience...',
                          ),
                          const SizedBox(height: 14),

                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: AppTheme.surface3,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.border,
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Checkbox(
                                        value: _privacyConsentGiven,
                                        onChanged: (value) {
                                          setState(() {
                                            _privacyConsentGiven =
                                                value ?? false;
                                          });
                                        },
                                        activeColor: AppTheme.primary,
                                        side: const BorderSide(
                                          color: AppTheme.mutedText,
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'I consent to my data being stored for programme matching and job applications. I understand my data is not shared externally.',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.mutedText,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Read our Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.primary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppTheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 0.5, color: AppTheme.border),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isSubmitting || !_privacyConsentGiven)
                          ? null
                          : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                        AppTheme.primary.withValues(alpha: 0.4),
                        padding: const EdgeInsets.symmetric(vertical: 13),
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
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : const Text('Submit Enrolment'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgrammeApplicationSuccessScreen extends StatelessWidget {
  final Programme programme;
  final ProgrammeApplicationData applicationData;
  final VoidCallback? onViewMyProgrammes;

  const ProgrammeApplicationSuccessScreen({
    super.key,
    required this.programme,
    required this.applicationData,
    this.onViewMyProgrammes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppTheme.successLow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppTheme.success,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Application Submitted!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your enrolment for ${programme.title} has been received and is now Pending review.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mutedText,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.border,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.mutedText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.warningLow,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onViewMyProgrammes ??
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyProgrammesScreen(),
                          ),
                        );
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
                  child: const Text('View My Programmes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool required;

  const _FieldLabel({
    required this.label,
    this.icon,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: AppTheme.mutedText),
          const SizedBox(width: 5),
        ],
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.mutedText,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.error,
            ),
          ),
      ],
    );
  }
}

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final String? hintText;
  final InputCounterWidgetBuilder? buildCounter;

  const _AppTextField({
    required this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.hintText,
    this.buildCounter,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      buildCounter: buildCounter,
      style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppTheme.subtleText, fontSize: 12),
        filled: true,
        fillColor: AppTheme.surface2,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.border2, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.border2, width: 0.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.error, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.error, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.0),
        ),
      ),
    );
  }
}