import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../services/auth_services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/error_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.resetPassword(
        email: _emailController.text.trim(),
        redirectTo: 'io.futurepath://reset-password',
      );

      if (mounted) setState(() => _isSuccess = true);
    } on AuthException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Something went wrong. Please try again.');
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: _isSuccess ? _buildSuccessView() : _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),
        // Back row — matches HTML auth back arrow pattern
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: const [
              Icon(Icons.arrow_back_ios, size: 16, color: AppTheme.mutedText),
              SizedBox(width: 6),
              Text(
                'Back to login',
                style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        // Brand row — matches HTML auth brand block
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
              children: const [
                Text(
                  'FuturePath',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  'Employment Hub',
                  style: TextStyle(fontSize: 10, color: AppTheme.mutedText),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        // Title block
        const Text(
          'Forgot password?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: TextStyle(fontSize: 11, color: AppTheme.mutedText),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email label
              const Text(
                'Email address',
                style: TextStyle(fontSize: 10, color: AppTheme.mutedText),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  hintStyle: const TextStyle(fontSize: 12, color: AppTheme.subtleText),
                  prefixIcon: const Icon(Icons.email_outlined, size: 16, color: AppTheme.subtleText),
                  filled: true,
                  fillColor: AppTheme.surface2,
                  contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
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
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email address';
                  }
                  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _handleForgotPassword(),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                ErrorMessage(message: _errorMessage!),
              ],
              const SizedBox(height: 20),
              // Primary button — matches HTML .pbtn
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleForgotPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: _isLoading
                      ? const LoadingIndicator(color: Colors.white)
                      : const Text('Send Reset Link'),
                ),
              ),
              const SizedBox(height: 8),
              // Secondary back button — matches HTML .sbtn
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.mutedText,
                    side: const BorderSide(color: AppTheme.border2, width: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        // Success icon circle — matches HTML .pi-circle style (amber-low bg)
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.successLow,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.check_rounded,
            size: 32,
            color: AppTheme.success,
          ),
        ),
        const SizedBox(height: 16),
        // Title
        const Text(
          'Check Your Email',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'If an account exists for ${_emailController.text}, '
              'we\'ve sent a password reset link to that address.',
          style: const TextStyle(fontSize: 12, color: AppTheme.mutedText, height: 1.6),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Submission detail card — matches HTML pending details card
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            border: Border.all(color: AppTheme.border, width: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SUBMISSION DETAILS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.mutedText,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _emailController.text,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Reset link sent successfully',
                style: TextStyle(fontSize: 10, color: AppTheme.mutedText),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Success notice — matches HTML green notice block
        Container(
          decoration: BoxDecoration(
            color: AppTheme.successLow,
            border: Border.all(color: AppTheme.success, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.check, size: 14, color: AppTheme.success),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'You can close the app and return once you\'ve checked your inbox.',
                  style: TextStyle(fontSize: 10, color: AppTheme.success),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Try again secondary button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => setState(() {
              _isSuccess = false;
              _errorMessage = null;
            }),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.mutedText,
              side: const BorderSide(color: AppTheme.border2, width: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 11),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text('Try Again'),
          ),
        ),
        const SizedBox(height: 8),
        // Back to login secondary button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.mutedText,
              side: const BorderSide(color: AppTheme.border2, width: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 11),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text('Back to Login'),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}