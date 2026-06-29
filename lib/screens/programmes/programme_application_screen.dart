// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-012
// ═══════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/models/programme.dart';
// ───────────────────────────────────────────────────────────────────────
// MODELS
// ───────────────────────────────────────────────────────────────────────

/// Local typed stand-in for the real applicant profile service.
/// Replace `mockApplicantProfile` with the real injected profile once
/// available — the shape (full name, SA ID, email, phone, CV) should
/// stay stable since application_service.dart will expect these fields.
class ApplicantProfile {
  final String fullName;
  final String saIdNumber;
  final String email;
  final String phone;
  final String? cvFileName; // null if no CV on file yet

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

/// Status values tracked for a programme application, per acceptance
/// criteria #6. Kept as a simple enum here — application_service.dart's
/// real backing type should mirror these three states.
enum ProgrammeApplicationStatus { pending, accepted, completed }

/// Payload submitted to application_service.dart with type: "programme".
class ProgrammeApplicationData {
  final String programmeId;
  final String fullName;
  final String saIdNumber;
  final String email;
  final String phone;
  final String? cvFileName;
  final String? motivationStatement; // optional
  final String? previousExperience; // optional
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

  // TODO(application_service): map this to the real request body once
  // application_service.dart exposes its "programme" type schema, e.g.:
  //   application_service.submit(type: "programme", payload: toJson());
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

/// Result returned by the (mock or real) submission call.
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

  ProgrammeApplyScreen({
    super.key,
    Programme? programme,
    this.applicantProfile = mockApplicantProfile,
    this.onSubmit,
    this.onSuccess,
    this.onClose,
  }) : programme = programme ?? mockProgrammes[1];

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

  static const int _motivationMaxLength = 500;

  @override
  void initState() {
    super.initState();
    // Auto-fill applicant fields from profile, per acceptance criteria #2.
    // Fields are editable (not read-only) so the applicant can correct
    // stale profile data without leaving this screen.
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
    // Release all text controllers to avoid leaks.
    _fullNameController.dispose();
    _saIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _motivationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _handleUploadCv() async {
    // TODO(file_picker): wire up real file picker (PDF, DOC) once the
    // file upload service exists. Mocked here so the flow is demoable.
    setState(() => _cvFileName = 'Sipho_Dlamini_CV.pdf');
  }

  Future<ApplicationResult> _mockSubmit(
      ProgrammeApplicationData data) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return const ApplicationResult.ok();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

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

    final submitFn = widget.onSubmit ?? _mockSubmit;
    final result = await submitFn(data);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result.success) {
      if (widget.onSuccess != null) {
        widget.onSuccess!(data);
      } else {
        // Fallback navigation if NAV-002 hasn't injected onSuccess yet —
        // pushes the success screen defined below in this same file.
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProgrammeApplicationSuccessScreen(
              programme: widget.programme,
              applicationData: data,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ?? 'Something went wrong. Please try again.',
          ),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.0),
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.92,
            ),
            decoration: const BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle, matches Figma reference
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
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
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.programme.title,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onClose ??
                                () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close,
                            color: AppTheme.mutedText),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppTheme.secondary),
                // Scrollable form body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Auto-fill banner, per acceptance criteria #2
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: const [
                                Text('✨', style: TextStyle(fontSize: 14)),
                                SizedBox(width: 8),
                                Text(
                                  'Details auto-filled from your profile',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          _FieldLabel(
                            icon: Icons.person_outline,
                            label: 'Full Name',
                            required: true,
                          ),
                          const SizedBox(height: 6),
                          _AppTextField(
                            controller: _fullNameController,
                            validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Full name is required'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel(
                            icon: Icons.tag,
                            label: 'SA ID Number',
                            required: true,
                          ),
                          const SizedBox(height: 6),
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
                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel(label: 'Email'),
                                    const SizedBox(height: 6),
                                    _AppTextField(
                                      controller: _emailController,
                                      keyboardType:
                                      TextInputType.emailAddress,
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
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel(label: 'Phone'),
                                    const SizedBox(height: 6),
                                    _AppTextField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      validator: (value) =>
                                      (value == null ||
                                          value.trim().isEmpty)
                                          ? 'Required'
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _FieldLabel(
                            icon: Icons.description_outlined,
                            label: 'CV / Resume',
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: _handleUploadCv,
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: double.infinity,
                              padding:
                              const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.mutedText.withOpacity(0.4),
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _cvFileName != null
                                        ? Icons.check_circle_outline
                                        : Icons.upload_outlined,
                                    color: _cvFileName != null
                                        ? AppTheme.accent
                                        : AppTheme.primary,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _cvFileName ?? 'Upload CV (PDF, DOC)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _cvFileName != null
                                          ? AppTheme.accent
                                          : AppTheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_cvFileName == null) ...[
                            const SizedBox(height: 6),
                            const Text(
                              'Add your CV to your profile to auto-fill this field',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.mutedText,
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),

                          const _FieldLabel(label: 'Cover Letter (Optional)'),
                          const SizedBox(height: 6),
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
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    '$currentLength/$maxLength',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.mutedText,
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 16),

                          const _FieldLabel(
                              label: 'Previous Experience (Optional)'),
                          const SizedBox(height: 6),
                          _AppTextField(
                            controller: _experienceController,
                            maxLines: 3,
                            hintText:
                            'Share any relevant prior experience...',
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: AppTheme.secondary),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                        AppTheme.primary.withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : const Text(
                        'Submit Enrolment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

// ───────────────────────────────────────────────────────────────────────
// SECTION 2: SUCCESS SCREEN
// ───────────────────────────────────────────────────────────────────────

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
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.accent,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Application Submitted!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your enrolment for ${programme.title} has been received and is now Pending review.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.mutedText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.secondary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.mutedText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onViewMyProgrammes ??
                          () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'View My Programmes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────
// SHARED PRESENTATION WIDGETS
// ───────────────────────────────────────────────────────────────────────
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
          Icon(icon, size: 15, color: AppTheme.mutedText),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
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
      style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppTheme.mutedText, fontSize: 13),
        filled: true,
        fillColor: AppTheme.secondary,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 14 : 24),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 14 : 24),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines > 1 ? 14 : 24),
          borderSide: const BorderSide(color: AppTheme.error, width: 1.5),
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-012
// ═══════════════════════════════════════════════════════════════════════
