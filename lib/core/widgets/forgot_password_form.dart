import 'package:flutter/material.dart';
import '../../services/auth_services.dart';
import 'loading_indicator.dart';
import 'error_message.dart';
import '../../core/theme/app_theme.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
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

  Future<void> _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.resetPassword(
        email: _emailController.text.trim(),
        redirectTo: 'io.futurepath://reset-password',
      );

      if (mounted) {
        setState(() {
          _isSuccess = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to send reset email. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return _buildSuccessView();
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label
          const Text(
            'Email address',
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.mutedText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textDark,
            ),
            decoration: InputDecoration(
              hintText: 'you@example.com',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: AppTheme.subtleText,
              ),
              prefixIcon: const Icon(
                Icons.email_outlined,
                size: 16,
                color: AppTheme.subtleText,
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.error,
                  width: 0.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.error,
                  width: 1,
                ),
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
            onFieldSubmitted: (_) => _handlePasswordReset(),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            ErrorMessage(message: _errorMessage!),
          ],
          const SizedBox(height: 20),
          // Primary button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePasswordReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.primaryDim,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: _isLoading
                  ? LoadingIndicator(color: Colors.white)
                  : const Text('Send Reset Link'),
            ),
          ),
          const SizedBox(height: 8),
          // Secondary back button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.mutedText,
                side: const BorderSide(
                  color: AppTheme.border2,
                  width: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 11),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              child: const Text('Back to Login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon circle — mirrors Staff Pending pi-circle pattern
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.successLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 32,
              color: AppTheme.success,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Title
        const Text(
          'Email Sent!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Subtitle
        // [UIUX-PRIV-002] — email address removed from success message.
        // Previously displayed: 'We\'ve sent a password reset link to\n${_emailController.text}'
        // Replaced with generic text to avoid echoing user PII in the UI.
        const Text(
          'We\'ve sent a password reset link to your email address.',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.mutedText,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Confirmation detail card — mirrors submission details card in Staff Pending
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            border: Border.all(color: AppTheme.border, width: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 3),
                decoration: const BoxDecoration(
                  color: AppTheme.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'You can close the app and return once you have clicked the link in your email.',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.success,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // Try again secondary button
        OutlinedButton(
          onPressed: () {
            setState(() {
              _isSuccess = false;
              _errorMessage = null;
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.mutedText,
            side: const BorderSide(
              color: AppTheme.border2,
              width: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 11),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          child: const Text('Didn\'t receive it? Try again'),
        ),
        const SizedBox(height: 8),
        // Back to login secondary button
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.mutedText,
            side: const BorderSide(
              color: AppTheme.border2,
              width: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 11),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}