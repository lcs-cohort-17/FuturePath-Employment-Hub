import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import '../../services/auth_services.dart';
import '../../services/staff_registration_service.dart';
import '../../router/app_router.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAdminLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.signIn(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (!mounted) return;

      final user = response.user;
      if (user == null) throw Exception('Login failed');

      // Check if user is actually an admin in the database
      final profile = await StaffRegistrationService.checkUserRole(user.id);
      
      if (!mounted) return;

      if (profile != null) {
        final role = profile['role'].toString().toLowerCase(); // Make case-insensitive
        debugPrint('Admin Login - Resolved Role: $role');
        
        if (role == 'admin') {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.adminStaffMgmt, 
            (route) => false,
          );
          return;
        }
      }
      
      setState(() => _errorMessage = 'Access denied. You are not an admin.');
      await _authService.signOut(); // Log out non-admin
    } on AuthException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Login failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildRestrictedWarning(),
              const SizedBox(height: 32),
              const Text(
                'Admin Sign In',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Use your provisioned credentials',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 32),
              _buildLoginForm(),
              const SizedBox(height: 32),
              const Text(
                'No self-registration available for admin accounts',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white24, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // [PLACEHOLDER UI] - Your team can replace this icon/header with official brand assets
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.security, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FuturePath',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Admin Portal',
              style: TextStyle(color: Color(0xFFE03A2F), fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRestrictedWarning() {
    // [PLACEHOLDER UI] - Adjust warning text colors or styles here
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE03A2F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE03A2F).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Restricted access.',
            style: TextStyle(color: Color(0xFFE03A2F), fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Admin credentials are provisioned directly via Supabase. Contact your technical lead if you need access.',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Admin email', style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          _textField(
            controller: _emailCtrl,
            hint: 'admin@futurepath.co.za',
            validator: (v) => (v == null || v.isEmpty) ? 'Admin email required' : null,
          ),
          const SizedBox(height: 20),
          const Text('Password', style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          _textField(
            controller: _passwordCtrl,
            hint: '••••••••••••',
            obscure: _obscurePassword,
            isPassword: true,
            onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
            validator: (v) => (v == null || v.isEmpty) ? 'Password required' : null,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
          ],
          const SizedBox(height: 32),
          // [PLACEHOLDER UI] - Button color and text for team review
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleAdminLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4), // Blue from design
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Sign In to Admin Panel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
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
}
