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
  final _loginEmailCtrl = TextEditingController(text: 'sipho.dlamini@gmail.com');
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

  /// Validates the login form, signs in via [AuthService], and routes to
  /// Home on success. Clears the navigation stack so the back button cannot
  /// return to Login. Shows a readable error message on failure rather than
  /// crashing.
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
                  const Text(
                    'Welcome back',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                  ),
                  const SizedBox(height: 28),
                  _buildLoginForm(),
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
              color: Colors.white.withValues(alpha: 0.15),
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
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
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
          if (_loginErrorMessage != null) ...[
            const SizedBox(height: 12),
            _errorBanner(_loginErrorMessage!),
          ],
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRouter.forgotPassword),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
              ),
              child: const Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
          _primaryButton(label: 'Log In', isLoading: _isLoading, onPressed: _handleLogin),
          const SizedBox(height: 20),
          _orDivider(),
          const SizedBox(height: 16),
          _googleButton(),
          const SizedBox(height: 20),
          _switchToSignupPrompt(),
        ],
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.primary.withValues(alpha: 0.6), width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
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

  Widget _primaryButton({required String label, required bool isLoading, required VoidCallback onPressed}) =>
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

  Widget _switchToSignupPrompt() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account?", style: TextStyle(color: AppTheme.mutedText)),
      const SizedBox(width: 4),
      GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(AppRouter.signup),
        child: const Text('Sign Up Free', style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700)),
      ),
    ],
  );
}