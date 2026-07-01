import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/employer.dart';
import '../../services/employer_service.dart';

/// Full-screen Add / Edit form for an [Employer].
/// Pass [employer] to enter edit mode; omit it for add mode.
class AdminEmployerFormScreen extends StatefulWidget {
  final Employer? employer;

  const AdminEmployerFormScreen({super.key, this.employer});

  bool get isEditing => employer != null;

  @override
  State<AdminEmployerFormScreen> createState() =>
      _AdminEmployerFormScreenState();
}

class _AdminEmployerFormScreenState extends State<AdminEmployerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final EmployerService _service = EmployerService();

  late final TextEditingController _companyName;
  late final TextEditingController _industry;
  late final TextEditingController _location;
  late final TextEditingController _contactEmail;
  late final TextEditingController _contactPhone;
  late final TextEditingController _website;
  late final TextEditingController _description;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.employer;
    _companyName = TextEditingController(text: e?.companyName ?? '');
    _industry = TextEditingController(text: e?.industry ?? '');
    _location = TextEditingController(text: e?.location ?? '');
    _contactEmail = TextEditingController(text: e?.contactEmail ?? '');
    _contactPhone = TextEditingController(text: e?.contactPhone ?? '');
    _website = TextEditingController(text: e?.website ?? '');
    _description = TextEditingController(text: e?.description ?? '');
  }

  @override
  void dispose() {
    _companyName.dispose();
    _industry.dispose();
    _location.dispose();
    _contactEmail.dispose();
    _contactPhone.dispose();
    _website.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final payload = {
        'company_name': _companyName.text.trim(),
        'industry': _industry.text.trim(),
        'location': _location.text.trim(),
        'contact_email': _contactEmail.text.trim(),
        'contact_phone': _contactPhone.text.trim(),
        'website': _website.text.trim(),
        'description': _description.text.trim(),
      };

      Employer result;
      if (widget.isEditing) {
        result = await _service.updateEmployer(widget.employer!.id, payload);
      } else {
        result = await _service.createEmployer(payload);
      }

      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save: $e',
              style:
              const TextStyle(color: AppTheme.textDark, fontSize: 12),
            ),
            backgroundColor: AppTheme.errorLow,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded,
              size: 18, color: AppTheme.mutedText),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          widget.isEditing ? 'Edit Employer' : 'Add Employer',
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: AppTheme.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: _submit,
                child: Text(
                  widget.isEditing ? 'Save' : 'Add',
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppTheme.border),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 40),
          children: [
            // ── Section: Core details ──────────────────────────────────────
            _sectionHeader('Company details'),
            _field(
              controller: _companyName,
              label: 'Company name',
              hint: 'e.g. Amazon SA',
              icon: Icons.business_outlined,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            _field(
              controller: _industry,
              label: 'Industry',
              hint: 'e.g. Technology, Retail, Finance',
              icon: Icons.category_outlined,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            _field(
              controller: _location,
              label: 'Location',
              hint: 'e.g. Cape Town, Western Cape',
              icon: Icons.location_on_outlined,
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 6),

            // ── Section: Contact ───────────────────────────────────────────
            _sectionHeader('Contact'),
            _field(
              controller: _contactEmail,
              label: 'Contact email',
              hint: 'hr@company.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null; // optional
                final emailRe = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                return emailRe.hasMatch(v.trim())
                    ? null
                    : 'Enter a valid email';
              },
            ),
            _field(
              controller: _contactPhone,
              label: 'Contact phone',
              hint: '+27 11 000 0000',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            _field(
              controller: _website,
              label: 'Website',
              hint: 'https://company.co.za',
              icon: Icons.language_outlined,
              keyboardType: TextInputType.url,
            ),

            const SizedBox(height: 6),

            // ── Section: About ─────────────────────────────────────────────
            _sectionHeader('About'),
            _multilineField(
              controller: _description,
              label: 'Description',
              hint:
              'Brief overview of the company, what they do, and the types of roles they typically post.',
            ),

            const SizedBox(height: 20),

            // ── Save button ────────────────────────────────────────────────
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: Text(widget.isEditing ? 'Save changes' : 'Add employer'),
            ),

            if (widget.isEditing) ...[
              const SizedBox(height: 10),
              // Destructive remove — delegates back to list screen via pop(null)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.errorLow.withOpacity(0.5), width: 0.5),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label,
              style: const TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppTheme.textDark, fontSize: 12),
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, size: 15, color: AppTheme.subtleText),
              prefixIconConstraints:
              const BoxConstraints(minWidth: 38, minHeight: 0),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _multilineField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label,
              style: const TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextFormField(
            controller: controller,
            maxLines: 4,
            style: const TextStyle(color: AppTheme.textDark, fontSize: 12),
            decoration: InputDecoration(
              hintText: hint,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }
}