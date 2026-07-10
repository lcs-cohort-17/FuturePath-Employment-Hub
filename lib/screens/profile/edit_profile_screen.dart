import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_profile_provider.dart';
import '../../models/user_profile.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserProfile profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _educationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final names = widget.profile.name.split(' ');
    _firstNameController = TextEditingController(text: names.isNotEmpty ? names[0] : '');
    _lastNameController = TextEditingController(text: names.length > 1 ? names.sublist(1).join(' ') : '');
    _locationController = TextEditingController(text: widget.profile.location);
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _educationController = TextEditingController(text: widget.profile.education ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    final updates = {
      'First_Name': _firstNameController.text.trim(),
      'Last_Name': _lastNameController.text.trim(),
      'Residential_Area': _locationController.text.trim(),
      'Contact_Number': _phoneController.text.trim(),
      'Highest_Qualification': _educationController.text.trim(),
    };

    final userId = widget.profile.userId;
    if (userId != null) {
      final success = await ref.read(userProfileProvider.notifier).saveProfile(userId, updates);
      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile'), backgroundColor: AppTheme.error),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        title: const Text('Edit Profile', style: TextStyle(color: AppTheme.textDark)),
        iconTheme: const IconThemeData(color: AppTheme.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField('First Name', _firstNameController),
            const SizedBox(height: 16),
            _buildTextField('Last Name', _lastNameController),
            const SizedBox(height: 16),
            _buildTextField('Location', _locationController),
            const SizedBox(height: 16),
            _buildTextField('Phone', _phoneController),
            const SizedBox(height: 16),
            _buildTextField('Education', _educationController),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppTheme.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.mutedText),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
