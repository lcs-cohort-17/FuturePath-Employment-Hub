import 'package:flutter/material.dart';
import '../../services/staff_registration_service.dart';
import '../../router/app_router.dart';

class StaffRegistrationScreen extends StatefulWidget {
  const StaffRegistrationScreen({super.key});

  @override
  State<StaffRegistrationScreen> createState() => _StaffRegistrationScreenState();
}

class _StaffRegistrationScreenState extends State<StaffRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _companyCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _showPendingModal() {
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
          'Your business account has been created! Please wait for an admin to approve your request. You will be notified via email once approved.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
            },
            child: const Text('Back to Login', style: TextStyle(color: Color(0xFFE03A2F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await StaffRegistrationService.registerStaff(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        companyName: _companyCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (!mounted) return;
      _showPendingModal();
      
    } catch (e) {
      if (mounted) {
        String displayError = e.toString();
        if (displayError.contains('User already registered')) {
          _showPendingModal();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Error: $displayError'), backgroundColor: Colors.redAccent),
          );
        }
      }
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
        title: const Text('Back to login', style: TextStyle(color: Colors.white70, fontSize: 14)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Register as Business',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  'Employer & recruiter accounts',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(child: _buildLabelAndField('First name', _firstNameCtrl, 'John')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildLabelAndField('Last name', _lastNameCtrl, 'Smith')),
                  ],
                ),
                const SizedBox(height: 20),
                _buildLabelAndField('Company name', _companyCtrl, 'e.g. Amazon SA'),
                const SizedBox(height: 20),
                _buildLabelAndField('Work email', _emailCtrl, 'work@company.com'),
                const SizedBox(height: 20),
                _buildLabelAndField('Password', _passwordCtrl, 'Min 8 characters', isPassword: true),
                
                const SizedBox(height: 32),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: const Text(
                    'Your account requires admin approval before accessing the dashboard.',
                    style: TextStyle(color: Colors.amber, fontSize: 13, height: 1.4),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE03A2F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Business Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelAndField(String label, TextEditingController ctrl, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          obscureText: isPassword && _obscurePassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF2C2E30),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white24),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                )
              : null,
          ),
          validator: (v) => (v == null || v.isEmpty) ? '$label required' : null,
        ),
      ],
    );
  }
}

class StaffPendingScreen extends StatelessWidget {
  const StaffPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_empty, color: Colors.amber, size: 64),
              const SizedBox(height: 24),
              const Text(
                'Registration Submitted',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your business account is pending approval from our admin team. You will be notified via email once active.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 48),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRouter.login, (route) => false),
                child: const Text('Back to Login', style: TextStyle(color: Color(0xFFE03A2F), fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
