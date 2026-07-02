import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../services/auth_services.dart';
import '../../router/app_router.dart';
// import '../../theme.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  Future<void> _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.updatePassword(_passwordController.text.trim());
      await _auth.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully! Please log in.'),
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
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 32, 22, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Brand header
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

                // Title + subtitle
                const Text(
                  'Create New Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Enter your new password below to update your account access.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 24),

                // Password field
                const Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Min 8 characters',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.subtleText,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppTheme.subtleText,
                      size: 16,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppTheme.subtleText,
                        size: 14,
                      ),
                    ),
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
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.trim().length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),

                // Info notice — matches amber notice style from Staff Register
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLow,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: AppTheme.warning.withOpacity(0.25),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline, color: AppTheme.warning, size: 14),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'After updating your password you will be signed out and redirected to login.',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Error message
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLow,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.error.withOpacity(0.3), width: 0.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline, color: AppTheme.error, size: 14),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Primary button / loading
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleUpdatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Update Password'),
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