//employer_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/employer.dart';
// import '../../theme.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';

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
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Center(
                child: Text(
                  'FP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 7),
            const Text(
              'Employer Profile',
              style: TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isMissingInfo ? AppTheme.warningLow : AppTheme.successLow,
                  border: Border.all(
                    color: isMissingInfo
                        ? AppTheme.warning.withOpacity(0.3)
                        : AppTheme.success.withOpacity(0.3),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  isMissingInfo ? 'Incomplete' : 'Verified',
                  style: TextStyle(
                    color: isMissingInfo ? AppTheme.warning : AppTheme.success,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: AppTheme.border, height: 0.5),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMissingInfo) _buildIncompleteWarning(),

            // HERO IDENTITY CARD
            Container(
              margin: const EdgeInsets.fromLTRB(14, 14, 14, 9),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppTheme.infoLow,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Text(
                        'EM',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.info,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                currentCompanyName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.successLow,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                '● Active',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          currentIndustry,
                          style: const TextStyle(fontSize: 10, color: AppTheme.mutedText),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 11, color: AppTheme.subtleText),
                            const SizedBox(width: 4),
                            Text(
                              currentLocation,
                              style: const TextStyle(fontSize: 9, color: AppTheme.subtleText),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.work_outline_rounded, size: 11, color: AppTheme.subtleText),
                            const SizedBox(width: 4),
                            Text(
                              '$currentOpenings open positions',
                              style: const TextStyle(fontSize: 9, color: AppTheme.subtleText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ABOUT COMPANY section header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'About Company',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ABOUT COMPANY card
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 9),
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: Text(
                rawBio ??
                    'No overview biography details have been published by this company. Please reach out via their direct contact channels for general inquiries.',
                style: TextStyle(
                  fontSize: 11,
                  color: rawBio != null ? AppTheme.mutedText : AppTheme.subtleText,
                  height: 1.6,
                  fontStyle: rawBio != null ? FontStyle.normal : FontStyle.italic,
                ),
              ),
            ),

            // ADDITIONAL INFORMATION section header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),

            // ADDITIONAL INFORMATION block
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: Column(
                children: [
                  _buildMetaRow(Icons.language_rounded, 'Website', rawWebsite, isLink: true),
                  Container(height: 0.5, color: AppTheme.border),
                  _buildMetaRow(Icons.email_outlined, 'Contact', currentEmail),
                  Container(height: 0.5, color: AppTheme.border),
                  _buildMetaRow(
                    Icons.work_outline_rounded,
                    'Active Openings',
                    currentOpenings > 0
                        ? '$currentOpenings Open Positions'
                        : 'No active positions listed',
                    isPlaceholder: currentOpenings == 0,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildNullState(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(color: AppTheme.border, height: 0.5),
        ),
        title: const Text(
          'Employer Detail',
          style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      body: const Center(
        child: Text(
          'No employer data provided.',
          style: TextStyle(color: AppTheme.mutedText, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildIncompleteWarning() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.warningLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.warning.withOpacity(0.25), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppTheme.warning, size: 14),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              'Some company details are currently pending verification. This section is being updated by our partner integration team.',
              style: TextStyle(fontSize: 10, color: AppTheme.warning, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(
      IconData icon,
      String label,
      String? value, {
        bool isLink = false,
        bool isPlaceholder = false,
      }) {
    final bool isEmpty = value == null || value.isEmpty;
    final String displayValue = isEmpty ? 'Not Listed' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.mutedText),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppTheme.mutedText),
          ),
          const Spacer(),
          Text(
            displayValue,
            style: TextStyle(
              fontSize: 11,
              fontWeight: (isEmpty || isPlaceholder) ? FontWeight.normal : FontWeight.w700,
              color: isLink && !isEmpty
                  ? AppTheme.info
                  : (isEmpty || isPlaceholder ? AppTheme.subtleText : AppTheme.textDark),
              fontStyle: (isEmpty || isPlaceholder) ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}