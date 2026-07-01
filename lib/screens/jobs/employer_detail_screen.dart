import 'package:flutter/material.dart';
import 'package:futurepath_employment_hub/models/employer.dart';

class EmployerDetailScreen extends StatelessWidget {
  final EmployerModel? employerData;

  const EmployerDetailScreen({
    super.key,
    this.employerData,
  });

  @override
  Widget build(BuildContext context) {
    final employer = employerData;

    if (employer == null) {
      return _buildNullState(context);
    }

    final bool isMissingInfo = employer.bio == null || employer.website == null;

    final String currentCompanyName = employer.companyName;
    final String currentIndustry = employer.industry;
    final String currentLocation = employer.location;
    final int currentOpenings = employer.activeOpeningsCount;
    final String currentEmail = employer.email ?? "support@employerplatform.internal";

    final String? rawBio = isMissingInfo ? null : employer.bio;
    final String? rawWebsite = isMissingInfo ? null : employer.website;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 85,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A365D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Employer Profile',
          style: TextStyle(color: Color(0xFF1A365D), fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isMissingInfo ? const Color(0xFFFFF7ED) : const Color(0xFFF0FDF4),
                  border: Border.all(color: isMissingInfo ? Colors.orange : const Color(0xFF008080)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isMissingInfo ? 'Incomplete Profile' : 'Verified Full Profile',
                  style: TextStyle(
                    color: isMissingInfo ? Colors.orange.shade800 : const Color(0xFF008080),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMissingInfo) _buildIncompleteWarning(),

            const SizedBox(height: 12),

            // HERO IDENTITY CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.business_rounded, color: Color(0xFF1A365D), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(currentCompanyName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)), overflow: TextOverflow.ellipsis),
                            ),
                            const Icon(Icons.verified_rounded, color: Color(0xFF008080), size: 16),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(currentIndustry, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF94A3B8)),
                            const SizedBox(width: 4),
                            Text(currentLocation, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ABOUT COMPANY
            const Text('About Company', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A365D), letterSpacing: 0.3)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Text(
                rawBio ?? 'No overview biography details have been published by this company. Please reach out via their direct contact channels for general inquiries.',
                style: TextStyle(
                  fontSize: 13,
                  color: rawBio != null ? const Color(0xFF475569) : const Color(0xFF64748B),
                  height: 1.5,
                  fontStyle: rawBio != null ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ADDITIONAL INFORMATION
            const Text('Additional Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A365D), letterSpacing: 0.3)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                children: [
                  _buildMetaRow(Icons.language_rounded, 'Website', rawWebsite, isLink: true),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(Icons.email_outlined, 'Contact', currentEmail),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(
                    Icons.business_center_outlined,
                    'Active Openings',
                    currentOpenings > 0 ? '$currentOpenings Open Positions' : 'No active positions listed',
                    isPlaceholder: currentOpenings == 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNullState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employer Detail')),
      body: const Center(child: Text('No employer data provided.')),
    );
  }

  Widget _buildIncompleteWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(26),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withAlpha(51)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Some company details are currently pending verification. This section is being updated by our partner integration team.',
              style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String label, String? value, {bool isLink = false, bool isPlaceholder = false}) {
    final bool isEmpty = value == null || value.isEmpty;
    final String displayValue = isEmpty ? 'Website Not Listed' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          const Spacer(),
          Text(
            displayValue,
            style: TextStyle(
              fontSize: 13,
              fontWeight: (isEmpty || isPlaceholder) ? FontWeight.normal : FontWeight.bold,
              color: isLink && !isEmpty
                  ? const Color(0xFF008080)
                  : (isEmpty || isPlaceholder ? const Color(0xFF94A3B8) : const Color(0xFF1E293B)),
              fontStyle: (isEmpty || isPlaceholder) ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
