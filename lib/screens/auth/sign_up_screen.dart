import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../core/theme/app_theme.dart';
import '../../services/auth_services.dart';
import '../../services/registration_service.dart';
import '../../router/app_router.dart';

class SignupScreen extends StatefulWidget {
  final AuthService? authService;
  const SignupScreen({super.key, this.authService});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final AuthService _authService = widget.authService ?? AuthService();

  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _genderCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _qualificationCtrl = TextEditingController();
  final _employmentCtrl = TextEditingController();
  final _skills = <String>[];

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  // [UIUX-PRIV-004] — privacy consent state
  bool _privacyConsented = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _genderCtrl.dispose();
    _phoneCtrl.dispose();
    _idCtrl.dispose();
    _areaCtrl.dispose();
    _qualificationCtrl.dispose();
    _employmentCtrl.dispose();
    super.dispose();
  }

  String? _validateRequired(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  /// Validates the full registration form, creates the Supabase auth
  /// account via [AuthService], saves the extended applicant profile, and
  /// shows a confirmation message on success. Shows a readable error
  /// message on failure rather than crashing.
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one skill.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    // [UIUX-PRIV-004] — block signup if consent not given
    if (!_privacyConsented) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the privacy consent to continue.'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Create the Auth account in Supabase
      final response = await _authService.signUp(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      // If signup returns a user but the session isn't immediate (e.g. email confirmation required)
      if (response.user == null) {
        throw Exception('Signup failed: No user returned.');
      }

      // 2. Save the additional profile data
      try {
        await RegistrationService.saveApplicant(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          idNumber: _idCtrl.text.trim(),
          dateOfBirth: _dobCtrl.text.trim(),
          gender: _genderCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          residentialArea: _areaCtrl.text.trim(),
          highestQualification: _qualificationCtrl.text.trim(),
          employmentStatus: _employmentCtrl.text.trim(),
          skills: _skills,
        );
      } catch (dbError) {
        debugPrint('Database Error: $dbError');
        if (mounted) {
           setState(() => _errorMessage = 'Account created, but profile details failed to save. Please contact support.');
        }
        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please check your email to confirm your account.'),
          backgroundColor: AppTheme.success,
        ),
      );

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.login,
            (route) => false,
      );
    } on AuthException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final genderOptions = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];
    final qualificationOptions = [
      'No Formal Education',
      'Primary School',
      'High School (Grade 9)',
      'Matric (Grade 12)',
      'Certificate',
      'Diploma',
      'Bachelor\'s Degree',
      'Honours Degree',
      'Master\'s Degree',
      'Doctoral Degree',
    ];

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back navigation row
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back_ios, color: AppTheme.mutedText, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Back to login',
                          style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Header — "Register as Employee"
                  const Text(
                    'Register as Employee',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Job seeker accounts',
                    style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                  ),
                  const SizedBox(height: 20),

                  // First name + Last name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('First name'),
                            const SizedBox(height: 4),
                            _textField(
                              controller: _firstNameCtrl,
                              hint: 'John',
                              validator: (v) => _validateRequired(v, 'First name'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Last name'),
                            const SizedBox(height: 4),
                            _textField(
                              controller: _lastNameCtrl,
                              hint: 'Smith',
                              validator: (v) => _validateRequired(v, 'Last name'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ID Number
                  _fieldLabel('ID Number'),
                  const SizedBox(height: 4),
                  _textField(
                    controller: _idCtrl,
                    hint: '13-digit SA ID number',
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'ID number is required';
                      if (v.trim().length != 13) return 'ID number must be 13 digits';
                      if (!RegExp(r'^\d{13}$').hasMatch(v.trim())) return 'ID number must contain only digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Date of Birth
                  _fieldLabel('Date of Birth'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _dobCtrl,
                    readOnly: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => _validateRequired(v, 'Date of birth'),
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1940),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        _dobCtrl.text =
                        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                      }
                    },
                    decoration: _fieldDecoration(
                      hint: 'DD/MM/YYYY',
                      prefix: const Icon(Icons.calendar_today_outlined, color: AppTheme.subtleText, size: 18),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Gender
                  _fieldLabel('Gender'),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _genderCtrl.text.isEmpty ? null : _genderCtrl.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => v == null ? 'Gender is required' : null,
                    decoration: _fieldDecoration(hint: 'Select gender'),
                    dropdownColor: AppTheme.surface3,
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
                    items: genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (v) => setState(() => _genderCtrl.text = v ?? ''),
                  ),
                  const SizedBox(height: 10),

                  // Contact Number
                  _fieldLabel('Contact Number'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Contact number is required';
                      if (!RegExp(r'^\+?[\d\s]{10,15}$').hasMatch(v.trim())) return 'Enter a valid contact number';
                      return null;
                    },
                    decoration: _fieldDecoration(
                      hint: '071 234 5678',
                      prefix: const Icon(Icons.phone_outlined, color: AppTheme.subtleText, size: 18),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Residential Area
                  _fieldLabel('Residential Area'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _areaCtrl,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
                    validator: (v) => _validateRequired(v, 'Residential area'),
                    decoration: _fieldDecoration(
                      hint: 'e.g. Cape Town',
                      prefix: const Icon(Icons.location_on_outlined, color: AppTheme.subtleText, size: 18),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Work email
                  _fieldLabel('Email address'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
                    validator: _validateEmail,
                    decoration: _fieldDecoration(
                      hint: 'you@example.com',
                      prefix: const Icon(Icons.email_outlined, color: AppTheme.subtleText, size: 18),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Highest Qualification
                  _fieldLabel('Highest Qualification'),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _qualificationCtrl.text.isEmpty ? null : _qualificationCtrl.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => v == null ? 'Qualification is required' : null,
                    decoration: _fieldDecoration(hint: 'Select qualification'),
                    dropdownColor: AppTheme.surface3,
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
                    items: qualificationOptions.map((q) => DropdownMenuItem(value: q, child: Text(q))).toList(),
                    onChanged: (v) => setState(() => _qualificationCtrl.text = v ?? ''),
                  ),
                  const SizedBox(height: 10),

                  // Employment Status
                  _fieldLabel('Current Employment Status'),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _employmentCtrl.text.isEmpty ? null : _employmentCtrl.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) => v == null ? 'Employment status is required' : null,
                    decoration: _fieldDecoration(hint: 'Select employment status'),
                    dropdownColor: AppTheme.surface3,
                    style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
                    items: [
                      'Employed (Full-time)',
                      'Employed (Part-time)',
                      'Self-employed',
                      'Unemployed',
                      'Student',
                    ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _employmentCtrl.text = v ?? ''),
                  ),
                  const SizedBox(height: 10),

                  // Skills
                  _fieldLabel('Skills'),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Communication',
                      'Leadership',
                      'Problem Solving',
                      'Teamwork',
                      'Computer Literacy',
                      'Customer Service',
                      'Project Management',
                      'Data Analysis',
                      'Marketing',
                      'Sales',
                    ].map((skill) {
                      final selected = _skills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: selected,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _skills.add(skill);
                            } else {
                              _skills.remove(skill);
                            }
                          });
                        },
                        backgroundColor: AppTheme.surface3,
                        selectedColor: AppTheme.primaryLow,
                        checkmarkColor: AppTheme.primary,
                        side: BorderSide(
                          color: selected ? AppTheme.primary : AppTheme.border,
                          width: 0.5,
                        ),
                        labelStyle: TextStyle(
                          color: selected ? AppTheme.primary : AppTheme.mutedText,
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // Password
                  _fieldLabel('Password'),
                  const SizedBox(height: 4),
                  _passwordField(
                    controller: _passwordCtrl,
                    hint: 'Min 6 characters',
                    obscure: _obscurePassword,
                    onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 10),

                  // Confirm Password
                  _fieldLabel('Confirm Password'),
                  const SizedBox(height: 4),
                  _passwordField(
                    controller: _confirmCtrl,
                    hint: 'Confirm password',
                    obscure: _obscureConfirm,
                    onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 14),

                  // Privacy consent checkbox
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surface2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _privacyConsented ? AppTheme.primary : AppTheme.border,
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
                                value: _privacyConsented,
                                onChanged: (val) => setState(() => _privacyConsented = val ?? false),
                                activeColor: AppTheme.primary,
                                side: const BorderSide(color: AppTheme.border2, width: 1),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'I consent to my data being stored for programme matching and job applications. I understand my data is not shared externally.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.mutedText,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // TODO: Open Privacy Policy
                          },
                          child: const Text(
                            'Read our Privacy Policy',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _errorBanner(_errorMessage!),
                  ],

                  const SizedBox(height: 14),

                  // Primary CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                          : const Text('Create Employee Account'),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Secondary "Back to login" text link
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
                              ),
                              TextSpan(
                                text: 'Log In',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorBanner(String message) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: AppTheme.errorLow,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.error, width: 0.5),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, color: AppTheme.error, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppTheme.error, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );

  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10,
      color: AppTheme.mutedText,
    ),
  );

  InputDecoration _fieldDecoration({required String hint, Widget? prefix, Widget? suffix}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppTheme.subtleText, fontSize: 11),
    prefixIcon: prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: AppTheme.surface2,
    contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
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
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppTheme.primary, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppTheme.error, width: 1),
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
        validator: validator,
        decoration: _fieldDecoration(hint: hint),
      );

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? hint,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        obscureText: obscure,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: AppTheme.textDark, fontSize: 11),
        validator: validator ?? (v) => _validateRequired(v, 'Password'),
        decoration: _fieldDecoration(
          hint: hint ?? 'Enter password',
          suffix: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppTheme.subtleText,
              size: 18,
            ),
            onPressed: onToggle,
          ),
        ),
      );
}
