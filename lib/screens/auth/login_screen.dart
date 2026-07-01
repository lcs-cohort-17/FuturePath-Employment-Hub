import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../core/theme/app_theme.dart';
import '../../services/auth_services.dart';
import '../../router/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();
  bool _loginObscure = true;

  bool _isLoading = false;
  String? _loginErrorMessage;

  @override
  void dispose() {
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    super.dispose();
  }

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

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _loginErrorMessage = null;
    });

    try {
      await _authService.signIn(
        email: _loginEmailCtrl.text.trim(),
        password: _loginPasswordCtrl.text,
      );

      if (!mounted) return;

      // TODO(INT-007): pass _loginEmailCtrl.text.trim() to load the user's
      // Google Sheets profile once that integration is wired up.

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.home,
            (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _loginErrorMessage = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loginErrorMessage = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 32, 22, 32),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo row
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'FP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FuturePath',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          'Employment Hub',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Welcome heading
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 24),

                // Email field
                _fieldLabel('Email address'),
                const SizedBox(height: 4),
                _emailField(_loginEmailCtrl),
                const SizedBox(height: 10),

                // Password field
                _fieldLabel('Password'),
                const SizedBox(height: 4),
                _passwordField(
                  controller: _loginPasswordCtrl,
                  obscure: _loginObscure,
                  onToggle: () => setState(() => _loginObscure = !_loginObscure),
                ),

                if (_loginErrorMessage != null) ...[
                  const SizedBox(height: 10),
                  _errorBanner(_loginErrorMessage!),
                ],

                // Forgot password
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(AppRouter.forgotPassword),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In button
                _primaryButton(
                  label: 'Sign In',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 18),

                // Don't have an account
                const Center(
                  child: Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Job Seeker / Business buttons
                Row(
                  children: [
                    Expanded(
                      child: _secondaryButton(
                        icon: Icons.person_outline,
                        label: 'Job Seeker',
                        onPressed: () => Navigator.of(context).pushNamed(AppRouter.signup),
                        borderColor: AppTheme.border2,
                        textColor: AppTheme.mutedText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _secondaryButton(
                        icon: Icons.business_outlined,
                        label: 'Business',
                        onPressed: () => Navigator.of(context).pushNamed(AppRouter.staffRegister),
                        borderColor: AppTheme.primary.withValues(alpha: 0.3),
                        textColor: AppTheme.primary,
                      ),
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
      color: AppTheme.errorLow,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, color: AppTheme.primary, size: 14),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 10,
      color: AppTheme.mutedText,
    ),
  );

  InputDecoration _fieldDecoration({
    required String hint,
    Widget? prefix,
    Widget? suffix,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppTheme.subtleText, fontSize: 12),
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: AppTheme.surface2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.border2, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.border2, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.error, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.error, width: 1),
        ),
      );

  Widget _emailField(TextEditingController ctrl) => TextFormField(
    controller: ctrl,
    keyboardType: TextInputType.emailAddress,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: _validateEmail,
    style: const TextStyle(color: AppTheme.textDark, fontSize: 12),
    decoration: _fieldDecoration(
      hint: 'you@example.com',
      prefix: const Icon(Icons.mail_outline, color: AppTheme.subtleText, size: 16),
    ),
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
        style: const TextStyle(color: AppTheme.textDark, fontSize: 12),
        decoration: _fieldDecoration(
          hint: hint ?? '••••••••',
          suffix: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppTheme.subtleText,
              size: 14,
            ),
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
        height: 46,
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          child: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
          )
              : const Text(
            'Sign In',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget _secondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color borderColor,
    required Color textColor,
  }) =>
      SizedBox(
        height: 42,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: BorderSide(color: borderColor, width: 0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      );
}