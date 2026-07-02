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
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signUp(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );

      await RegistrationService.saveApplicant(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        idNumber: _idCtrl.text.trim(),
        dateOfBirth: _dobCtrl.text.trim(),
        gender: _genderCtrl.text.trim(),
        contactNumber: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        residentialArea: _areaCtrl.text.trim(),
        highestQualification: _qualificationCtrl.text.trim(),
        employmentStatus: _employmentCtrl.text.trim(),
        skills: _skills,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created! Please check your email to confirm your account.'),
          backgroundColor: Colors.green,
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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
                const SizedBox(height: 6),
                Text(
                  'Join FuturePath Employment Hub',
                  style: TextStyle(color: AppTheme.mutedText, fontSize: 14),
                ),
                const SizedBox(height: 28),

                _fieldLabel('First Name'),
                const SizedBox(height: 6),
                _textField(controller: _firstNameCtrl, hint: 'Your first name', validator: (v) => _validateRequired(v, 'First name')),
                const SizedBox(height: 16),

                _fieldLabel('Last Name'),
                const SizedBox(height: 6),
                _textField(controller: _lastNameCtrl, hint: 'Your last name', validator: (v) => _validateRequired(v, 'Last name')),
                const SizedBox(height: 16),

                _fieldLabel('ID Number'),
                const SizedBox(height: 6),
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
                const SizedBox(height: 16),

                _fieldLabel('Date of Birth'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) => _validateRequired(v, 'Date of birth'),
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
                    prefix: const Icon(Icons.calendar_today_outlined, color: AppTheme.mutedText, size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Gender'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _genderCtrl.text.isEmpty ? null : _genderCtrl.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) => v == null ? 'Gender is required' : null,
                  decoration: _fieldDecoration(hint: 'Select gender'),
                  items: genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => setState(() => _genderCtrl.text = v ?? ''),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Contact Number'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Contact number is required';
                    if (!RegExp(r'^\+?[\d\s]{10,15}$').hasMatch(v.trim())) return 'Enter a valid contact number';
                    return null;
                  },
                  decoration: _fieldDecoration(
                    hint: '071 234 5678',
                    prefix: const Icon(Icons.phone_outlined, color: AppTheme.mutedText, size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Email Address'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validateEmail,
                  decoration: _fieldDecoration(
                    hint: 'you@email.com',
                    prefix: const Icon(Icons.email_outlined, color: AppTheme.mutedText, size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Residential Area'),
                const SizedBox(height: 6),
                _textField(controller: _areaCtrl, hint: 'e.g. Soweto, Johannesburg', validator: (v) => _validateRequired(v, 'Residential area')),
                const SizedBox(height: 16),

                _fieldLabel('Highest Qualification'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _qualificationCtrl.text.isEmpty ? null : _qualificationCtrl.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) => v == null ? 'Qualification is required' : null,
                  decoration: _fieldDecoration(hint: 'Select qualification'),
                  items: qualificationOptions.map((q) => DropdownMenuItem(value: q, child: Text(q))).toList(),
                  onChanged: (v) => setState(() => _qualificationCtrl.text = v ?? ''),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Current Employment Status'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _employmentCtrl.text.isEmpty ? null : _employmentCtrl.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (v) => v == null ? 'Employment status is required' : null,
                  decoration: _fieldDecoration(hint: 'Select employment status'),
                  items: [
                    'Employed (Full-time)',
                    'Employed (Part-time)',
                    'Self-employed',
                    'Unemployed',
                    'Student',
                  ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _employmentCtrl.text = v ?? ''),
                ),
                const SizedBox(height: 16),

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
                      selectedColor: AppTheme.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppTheme.primary,
                      labelStyle: TextStyle(
                        color: selected ? AppTheme.primary : AppTheme.mutedText,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                _fieldLabel('Password'),
                const SizedBox(height: 6),
                _passwordField(
                  controller: _passwordCtrl,
                  obscure: _obscurePassword,
                  onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),

                _fieldLabel('Confirm Password'),
                const SizedBox(height: 6),
                _passwordField(
                  controller: _confirmCtrl,
                  hint: 'Confirm password',
                  obscure: _obscureConfirm,
                  onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  validator: _validateConfirmPassword,
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _errorBanner(_errorMessage!),
                ],

                const SizedBox(height: 28),
                SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                        : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?', style: TextStyle(color: AppTheme.mutedText)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text('Log In', style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
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
      color: Colors.redAccent.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message, style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );

  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textDark),
  );

  InputDecoration _fieldDecoration({required String hint, Widget? prefix, Widget? suffix}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppTheme.mutedText),
    prefixIcon: prefix,
    suffixIcon: suffix,
    filled: true,
    fillColor: const Color(0xFFF0F4F8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.primary.withValues(alpha: 0.6), width: 1.5)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
  );

  Widget _textField({required TextEditingController controller, required String hint, String? Function(String?)? validator}) => TextFormField(
    controller: controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
    decoration: _fieldDecoration(hint: hint),
  );

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? hint,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    obscureText: obscure,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator ?? (v) => _validateRequired(v, 'Password'),
    decoration: _fieldDecoration(
      hint: hint ?? 'Enter password',
      prefix: const Icon(Icons.lock_outline, color: AppTheme.mutedText, size: 20),
      suffix: IconButton(
        icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.mutedText, size: 20),
        onPressed: onToggle,
      ),
    ),
  );
}