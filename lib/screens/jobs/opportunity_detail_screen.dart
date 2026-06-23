import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/opportunity.dart';
import 'job_apply_screen.dart';

class OpportunityDetailScreen extends StatelessWidget {
  final Opportunity? opportunity;

  const OpportunityDetailScreen({super.key, this.opportunity});

  @override
  Widget build(BuildContext context) {
    // Fallback mock data if none provided
    final job = opportunity ?? const Opportunity(
      id: 'JOB-2026',
      title: 'Junior Developer',
      company: 'FuturePath Tech',
      companyIndustry: 'Technology',
      location: 'Remote',
      jobType: 'Full-time',
      skills: ['Flutter', 'Dart'],
      closingDate: '31 Dec 2026',
      positions: 1,
      salaryRange: 'Market Related',
      isOpen: true,
      description: 'We are looking for a Junior Developer to join our team...',
      relatedProgrammes: [],
      logoInitials: 'FP',
      logoColor: AppTheme.primary,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: job.logoColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      job.logoInitials,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        job.company,
                        style: const TextStyle(fontSize: 16, color: AppTheme.accent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _infoRow(Icons.location_on_outlined, job.location),
            const SizedBox(height: 8),
            _infoRow(Icons.work_outline, job.jobType),
            const SizedBox(height: 8),
            _infoRow(Icons.calendar_today_outlined, 'Closes ${job.closingDate}'),
            const SizedBox(height: 24),
            const Text(
              'Job Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              job.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Required Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.skills.map((s) => Chip(label: Text(s))).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplyScreen(
                        jobId: job.id,
                        jobTitle: job.title,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.mutedText),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, color: AppTheme.mutedText)),
      ],
    );
  }
}
