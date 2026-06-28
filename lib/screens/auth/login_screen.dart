import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../core/theme/app_theme.dart';
import '../../services/auth_services.dart';
import '../../services/staff_registration_service.dart';
import '../../router/app_router.dart';
import 'staff_registration_screen.dart'; // Import for StaffPendingScreen

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

  void _showPendingApprovalDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2E30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.hourglass_empty, color: Colors.amber),
            SizedBox(width: 12),
            Text('Pending Approval', style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        content: const Text(
          'Your business account is still pending approval from our admin team. You will be notified via email once approved.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: Color(0xFFE03A2F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _loginErrorMessage = null;
    });

    try {
      final response = await _authService.signIn(
        email: _loginEmailCtrl.text.trim(),
        password: _loginPasswordCtrl.text,
      );

      final user = response.user;
      if (user == null) throw Exception('Login failed');

      if (!mounted) return;

      // Check user role and status from Supabase
      final profile = await StaffRegistrationService.checkUserRole(user.id);
      
      if (!mounted) return;

      if (profile != null) {
        final role = profile['role'];
        final status = profile['status'];

        if (role == 'staff') {
          if (status == 'active') {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.staffDashboard, (route) => false);
          } else if (status == 'pending_approval') {
            // Block login and sign out
            await _authService.signOut();
            if (!mounted) return;
            _showPendingApprovalDialog();
          } else {
            await _authService.signOut();
            setState(() => _loginErrorMessage = 'Your business account is suspended.');
          }
          return;
        } else if (role == 'admin') {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.adminStaffMgmt, (route) => false);
          return;
        }
      }

      // Default for job seekers or if no profile found yet
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
      backgroundColor: const Color(0xFF1A1C1E), // Dark background from design
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 48),
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              _buildLoginForm(),
              const SizedBox(height: 24),
              _buildRoleSpecificNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFE03A2F), // Brand red
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'FP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FuturePath',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Employment Hub',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Email address',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _textField(
            controller: _loginEmailCtrl,
            hint: 'you@example.com',
            validator: _validateEmail,
          ),
          const SizedBox(height: 20),
          const Text(
            'Password',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _textField(
            controller: _loginPasswordCtrl,
            hint: '••••••••',
            obscure: _loginObscure,
            isPassword: true,
            onToggleVisibility: () => setState(() => _loginObscure = !_loginObscure),
            validator: (v) => _validateRequired(v, 'Password'),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRouter.forgotPassword),
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: Color(0xFFE03A2F)),
              ),
            ),
          ),
          if (_loginErrorMessage != null) ...[
            _errorBanner(_loginErrorMessage!),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 16),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE03A2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificNavigation() {
    return Column(
      children: [
        const Text(
          "Don't have an account?",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.signup),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Job Seeker', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRouter.staffSignup),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFE03A2F)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Business', style: TextStyle(color: Color(0xFFE03A2F))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(AppRouter.adminLogin),
          child: const Text(
            'Admin Login',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: const Color(0xFF2C2E30),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white24),
          onPressed: onToggleVisibility,
        )
            : null,
      ),
    );
  }

  Widget _errorBanner(String message) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.redAccent.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
        ),
      ],
    ),
  );
}
