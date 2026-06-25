import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import 'package:futurepath_employment_hub/screens/staff/staff_pending_screen.dart';
// import '../services/staff_service.dart';

class StaffRegistrationScreen extends StatefulWidget {
  const StaffRegistrationScreen({super.key});

  @override
  State<StaffRegistrationScreen> createState() =>
      _StaffRegistrationScreenState();
}

class _StaffRegistrationScreenState extends State<StaffRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _workEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _workEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? '$label is required' : null;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Work email is required';
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Min 8 characters';
    return null;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Replace with the real INT-010 call, e.g.:
      // await StaffService.instance.registerStaff(
      //   firstName: _firstNameController.text.trim(),
      //   lastName: _lastNameController.text.trim(),
      //   companyName: _companyNameController.text.trim(),
      //   workEmail: _workEmailController.text.trim(),
      //   password: _passwordController.text,
      // );

      final submissionData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'companyName': _companyNameController.text.trim(),
        'workEmail': _workEmailController.text.trim(),
        'timestamp': DateTime.now(),
      };

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StaffPendingScreen(submissionData: submissionData),
        ),
      );
    } catch (e) {
      setState(() => _errorMessage = 'Registration failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surf,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back to login
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, size: 16, color: AppColors.t2),
                      SizedBox(width: 8),
                      Text(
                        'Back to login',
                        style: TextStyle(fontSize: 11, color: AppColors.t2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Register as Business',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.t1,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Employer & recruiter accounts',
                  style: TextStyle(fontSize: 11, color: AppColors.t2),
                ),
                const SizedBox(height: 20),

                // First name / Last name row
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First name',
                        controller: _firstNameController,
                        hint: 'John',
                        validator: (v) => _required(v, 'First name'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppTextField(
                        label: 'Last name',
                        controller: _lastNameController,
                        hint: 'Smith',
                        validator: (v) => _required(v, 'Last name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                AppTextField(
                  label: 'Company name',
                  controller: _companyNameController,
                  hint: 'e.g. Amazon SA',
                  validator: (v) => _required(v, 'Company name'),
                ),
                const SizedBox(height: 10),

                AppTextField(
                  label: 'Work email',
                  controller: _workEmailController,
                  hint: 'work@company.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 10),

                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  hint: 'Min 8 characters',
                  obscure: _obscurePassword,
                  validator: _validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 16,
                      color: AppColors.t3,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: 14),

                // Amber warning notice — matches design exactly
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.amberLow,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.amber.withOpacity(0.25)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 14, color: AppColors.amber),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Your account requires admin approval before accessing the dashboard.',
                          style: TextStyle(fontSize: 10, color: AppColors.amber),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.brand, fontSize: 11),
                  ),
                ],
                const SizedBox(height: 14),

                PrimaryButton(
                  label: 'Create Business Account',
                  onPressed: _handleSubmit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
