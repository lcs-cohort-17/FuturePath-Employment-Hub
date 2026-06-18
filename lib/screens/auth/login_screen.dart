import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/registration_service.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoginTab = true;

  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmailCtrl = TextEditingController(text: 'sipho.dlamini@gmail.com');
  final _loginPasswordCtrl = TextEditingController();
  bool _loginObscure = true;

  final _signupFormKey = GlobalKey<FormState>();
  final _signupNameCtrl = TextEditingController();
  final _signupEmailCtrl = TextEditingController();
  final _signupPasswordCtrl = TextEditingController();
  final _signupConfirmCtrl = TextEditingController();
  final _signupFirstNameCtrl = TextEditingController();
  final _signupLastNameCtrl = TextEditingController();
  final _signupDobCtrl = TextEditingController();
  final _signupGenderCtrl = TextEditingController();
  final _signupPhoneCtrl = TextEditingController();
  final _signupIdCtrl = TextEditingController();
  final _signupAreaCtrl = TextEditingController();
  final _signupQualificationCtrl = TextEditingController();
  final _signupEmploymentCtrl = TextEditingController();
  final _signupSkillsCtrl = <String>[];

  bool _signupObscure = true;
  bool _signupConfirmObscure = true;

  bool _isLoading = false;
  String? _loginError;
  String? _signupError;
  String? _signupSuccess;

  @override
  void dispose() {
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _signupNameCtrl.dispose();
    _signupEmailCtrl.dispose();
    _signupPasswordCtrl.dispose();
    _signupConfirmCtrl.dispose();
    _signupFirstNameCtrl.dispose();
    _signupLastNameCtrl.dispose();
    _signupDobCtrl.dispose();
    _signupGenderCtrl.dispose();
    _signupPhoneCtrl.dispose();
    _signupIdCtrl.dispose();
    _signupAreaCtrl.dispose();
    _signupQualificationCtrl.dispose();
    _signupEmploymentCtrl.dispose();
    super.dispose();
  }

  // --- Validators ---
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validateRequired(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  String? _validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _signupPasswordCtrl.text) return 'Passwords do not match';
    return null;
  }

  // --- Login Handler (Enhanced with Debug Logging) ---
  Future<void> _login() async {
    if (!_loginFormKey.currentState!.validate()) {
      debugPrint('Login form validation failed.');
      return;
    }

    debugPrint('Login form validation passed. Starting login...');
    setState(() {
      _isLoading = true;
      _loginError = null;
    });

    final email = _loginEmailCtrl.text.trim();
    final password = _loginPasswordCtrl.text.trim();

    try {
      debugPrint('Attempting login with email: $email');
      await ref.read(authNotifierProvider.notifier).signIn(email, password);
      debugPrint('Login successful – navigating to /home');
      if (mounted) {
        context.go('/home');
      }
    } catch (e, stackTrace) {
      // Detailed logging
      debugPrint('===== LOGIN ERROR =====');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');

      // Extract user-friendly message
      final message = _getUserFriendlyErrorMessage(e);
      debugPrint('User-friendly message: $message');

      // Update UI state
      setState(() {
        _loginError = message;
        _isLoading = false;
      });
      debugPrint('State updated. _loginError = $_loginError');

      // Fallback: show SnackBar to ensure user sees error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      // Only clear loading if no error was set
      if (mounted && _loginError == null) {
        debugPrint('No error, clearing loading state');
        setState(() => _isLoading = false);
      }
    }
  }

  // --- Sign-Up Handler ---
  Future<void> _signup() async {
    if (!_signupFormKey.currentState!.validate()) return;
    if (_signupSkillsCtrl.isEmpty) {
      setState(() {
        _signupError = 'Please select at least one skill.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _signupError = null;
      _signupSuccess = null;
    });

    final email = _signupEmailCtrl.text.trim();
    final password = _signupPasswordCtrl.text.trim();

    try {
      // 1. Create Supabase user
      await ref.read(authNotifierProvider.notifier).signUp(email, password);

      // 2. Save applicant profile to Google Sheets (existing service)
      await RegistrationService.saveApplicant(
        firstName: _signupFirstNameCtrl.text.trim(),
        lastName: _signupLastNameCtrl.text.trim(),
        idNumber: _signupIdCtrl.text.trim(),
        dateOfBirth: _signupDobCtrl.text.trim(),
        gender: _signupGenderCtrl.text.trim(),
        contactNumber: _signupPhoneCtrl.text.trim(),
        email: email,
        residentialArea: _signupAreaCtrl.text.trim(),
        highestQualification: _signupQualificationCtrl.text.trim(),
        employmentStatus: _signupEmploymentCtrl.text.trim(),
        skills: _signupSkillsCtrl,
      );

      setState(() {
        _signupSuccess = 'Account created! You can now log in.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _signupError = 'Sign-up failed: ${_getUserFriendlyErrorMessage(e)}';
        _isLoading = false;
      });
    } finally {
      if (mounted && _signupError == null && _signupSuccess == null) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getUserFriendlyErrorMessage(dynamic error) {
    // Handle Supabase AuthException
    if (error is AuthException) {
      debugPrint('AuthException statusCode: ${error.statusCode}, message: ${error.message}');
      switch (error.statusCode) {
        case '400':
          return 'Invalid email or password.';
        case '422':
          return 'Please check your email format.';
        case 'user_already_exists':
          return 'An account with this email already exists.';
        case 'email_not_confirmed':
          return 'Please confirm your email address before logging in.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }

    // Handle error objects with a message property
    if (error is Exception && error.toString().contains('message')) {
      try {
        final message = error.toString().split('message: ').last;
        if (message.contains('Invalid login credentials')) {
          return 'Invalid email or password.';
        }
        if (message.contains('Email not confirmed')) {
          return 'Please confirm your email address before logging in.';
        }
        return message.length < 60 ? message : 'Something went wrong. Please try again.';
      } catch (_) {
        return 'Something went wrong. Please try again.';
      }
    }

    // Handle generic exceptions
    if (error is Exception && error.toString().isNotEmpty) {
      final msg = error.toString();
      if (msg.contains('Invalid login credentials')) {
        return 'Invalid email or password.';
      }
      if (msg.contains('Email not confirmed')) {
        return 'Please confirm your email address before logging in.';
      }
    }

    // Handle error objects with a statusCode property
    if (error is dynamic && error is Map<String, dynamic>) {
      final statusCode = error['statusCode'] ?? error['code'];
      if (statusCode == '400') {
        return 'Invalid email or password.';
      }
      if (statusCode == '422') {
        return 'Please check your email format.';
      }
    }

    // Default fallback
    return 'Something went wrong. Please try again.';
  }

  // --- UI Build ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTabToggle(),
                  const SizedBox(height: 28),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _isLoginTab ? _buildLoginForm() : _buildSignupForm(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppTheme.primary,
      padding: const EdgeInsets.only(top: 60, bottom: 32),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.work_outline_rounded, size: 38, color: Colors.white),
          ),
          const SizedBox(height: 14),
          const Text(
            'FuturePath',
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Employment Hub',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _tabOption('Log In', isActive: _isLoginTab, onTap: () => setState(() => _isLoginTab = true)),
          _tabOption('Sign Up', isActive: !_isLoginTab, onTap: () => setState(() => _isLoginTab = false)),
        ],
      ),
    );
  }

  Widget _tabOption(String label, {required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 15,
              color: isActive ? AppTheme.textDark : AppTheme.mutedText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('login'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fieldLabel('Email Address'),
          const SizedBox(height: 6),
          _emailField(_loginEmailCtrl),
          const SizedBox(height: 16),
          _fieldLabel('Password'),
          const SizedBox(height: 6),
          _passwordField(
            controller: _loginPasswordCtrl,
            obscure: _loginObscure,
            onToggle: () => setState(() => _loginObscure = !_loginObscure),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.pushNamed('forgot-password'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
              ),
              child: const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          if (_loginError != null) ...[
            const SizedBox(height: 8),
            Text(
              _loginError!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          _primaryButton(label: 'Log In', isLoading: _isLoading, onPressed: _login),
          const SizedBox(height: 20),
          _orDivider(),
          const SizedBox(height: 16),
          _googleButton(),
          const SizedBox(height: 20),
          _switchTabPrompt(
            question: "Don't have an account?",
            action: 'Sign Up Free',
            onTap: () => setState(() => _isLoginTab = false),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
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

    return Form(
      key: _signupFormKey,
      child: Column(
        key: const ValueKey('signup'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fieldLabel('First Name'),
          const SizedBox(height: 6),
          _textField(
            controller: _signupFirstNameCtrl,
            hint: 'Your first name',
            validator: (v) => _validateRequired(v, 'First name'),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Last Name'),
          const SizedBox(height: 6),
          _textField(
            controller: _signupLastNameCtrl,
            hint: 'Your last name',
            validator: (v) => _validateRequired(v, 'Last name'),
          ),
          const SizedBox(height: 16),
          _fieldLabel('ID Number'),
          const SizedBox(height: 6),
          _textField(
            controller: _signupIdCtrl,
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
            controller: _signupDobCtrl,
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
                _signupDobCtrl.text =
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
            value: _signupGenderCtrl.text.isEmpty ? null : _signupGenderCtrl.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) => v == null ? 'Gender is required' : null,
            decoration: _fieldDecoration(hint: 'Select gender'),
            items: genderOptions
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (v) => setState(() => _signupGenderCtrl.text = v ?? ''),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Contact Number'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _signupPhoneCtrl,
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
          _emailField(_signupEmailCtrl),
          const SizedBox(height: 16),
          _fieldLabel('Residential Area'),
          const SizedBox(height: 6),
          _textField(
            controller: _signupAreaCtrl,
            hint: 'e.g. Soweto, Johannesburg',
            validator: (v) => _validateRequired(v, 'Residential area'),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Highest Qualification'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _signupQualificationCtrl.text.isEmpty ? null : _signupQualificationCtrl.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) => v == null ? 'Qualification is required' : null,
            decoration: _fieldDecoration(hint: 'Select qualification'),
            items: qualificationOptions
                .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                .toList(),
            onChanged: (v) => setState(() => _signupQualificationCtrl.text = v ?? ''),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Current Employment Status'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _signupEmploymentCtrl.text.isEmpty ? null : _signupEmploymentCtrl.text,
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
            onChanged: (v) => setState(() => _signupEmploymentCtrl.text = v ?? ''),
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
              final selected = _signupSkillsCtrl.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _signupSkillsCtrl.add(skill);
                    } else {
                      _signupSkillsCtrl.remove(skill);
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
            controller: _signupPasswordCtrl,
            obscure: _signupObscure,
            onToggle: () => setState(() => _signupObscure = !_signupObscure),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Confirm Password'),
          const SizedBox(height: 6),
          _passwordField(
            controller: _signupConfirmCtrl,
            hint: 'Confirm password',
            obscure: _signupConfirmObscure,
            onToggle: () => setState(() => _signupConfirmObscure = !_signupConfirmObscure),
            validator: _validateConfirmPassword,
          ),
          const SizedBox(height: 24),
          if (_signupError != null) ...[
            Text(_signupError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
          ],
          if (_signupSuccess != null) ...[
            Text(_signupSuccess!, style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 8),
          ],
          _primaryButton(label: 'Create Account', isLoading: _isLoading, onPressed: _signup),
          const SizedBox(height: 20),
          _orDivider(),
          const SizedBox(height: 16),
          _googleButton(),
          const SizedBox(height: 20),
          _switchTabPrompt(
            question: 'Already have an account?',
            action: 'Log In',
            onTap: () => setState(() => _isLoginTab = true),
          ),
        ],
      ),
    );
  }

  // --- Helper widgets ---
  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textDark),
  );

  InputDecoration _fieldDecoration({required String hint, Widget? prefix, Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.mutedText),
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.6), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      );

  Widget _emailField(TextEditingController ctrl) => TextFormField(
    controller: ctrl,
    keyboardType: TextInputType.emailAddress,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: _validateEmail,
    decoration: _fieldDecoration(
      hint: 'you@email.com',
      prefix: const Icon(Icons.email_outlined, color: AppTheme.mutedText, size: 20),
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

  Widget _primaryButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) =>
      SizedBox(
        height: 54,
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: isLoading
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
              : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      );

  Widget _orDivider() => Row(
    children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('or continue with', style: TextStyle(color: AppTheme.mutedText, fontSize: 13)),
      ),
      const Expanded(child: Divider()),
    ],
  );

  Widget _googleButton() => OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      side: const BorderSide(color: Color(0xFFDDE3ED)),
      backgroundColor: Colors.white,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4285F4))),
        const SizedBox(width: 10),
        Text('Continue with Google', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
      ],
    ),
  );

  Widget _switchTabPrompt({
    required String question,
    required String action,
    required VoidCallback onTap,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question, style: const TextStyle(color: AppTheme.mutedText)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onTap,
            child: Text(action, style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700)),
          ),
        ],
      );
}