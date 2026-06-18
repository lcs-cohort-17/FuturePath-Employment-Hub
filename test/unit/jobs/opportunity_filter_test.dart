import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/screens/jobs/job_list_screen.dart';
import 'dart:ui';  // ← ADD THIS for Color

void main() {
  group('Opportunity Filter Logic Tests', () {
    final mockJobs = [
      Opportunity(
        id: '1',
        title: 'Flutter Developer',
        company: 'TechNova',
        companyIndustry: 'Tech',
        location: 'Cape Town',
        jobType: 'Full-time',
        skills: ['Flutter', 'Dart'],
        closingDate: '31 Jul 2026',
        positions: 3,
        salaryRange: 'R18,000 – R25,000',
        isOpen: true,
        description: 'Test description',
        relatedProgrammes: [],
        logoInitials: 'T',
        logoColor: const Color(0xFF008080),
      ),
      Opportunity(
        id: '2',
        title: 'Python Developer',
        company: 'Innovate SA',
        companyIndustry: 'Tech',
        location: 'Durban',
        jobType: 'Full-time',
        skills: ['Python', 'SQL'],
        closingDate: '01 Aug 2026',
        positions: 5,
        salaryRange: 'R14,000',
        isOpen: true,
        description: 'Test description',
        relatedProgrammes: [],
        logoInitials: 'I',
        logoColor: const Color(0xFF008080),
      ),
      Opportunity(
        id: '3',
        title: 'Salesforce Intern',
        company: 'FutureTech',
        companyIndustry: 'Business',
        location: 'Johannesburg',
        jobType: 'Internship',
        skills: ['Salesforce', 'CRM'],
        closingDate: '15 Jul 2026',
        positions: 2,
        salaryRange: 'R10,000',
        isOpen: true,
        description: 'Test description',
        relatedProgrammes: [],
        logoInitials: 'F',
        logoColor: const Color(0xFF7C3AED),
      ),
    ];

    test('Filter by skill "Flutter" returns only Flutter jobs', () {
      const selectedSkill = 'Flutter';

      final filtered = mockJobs.where((job) =>
          job.skills.any((skill) => skill.toLowerCase() == selectedSkill.toLowerCase())).toList();

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Flutter Developer');
    });

    test('Filter by skill "Python" returns only Python jobs', () {
      const selectedSkill = 'Python';

      final filtered = mockJobs.where((job) =>
          job.skills.any((skill) => skill.toLowerCase() == selectedSkill.toLowerCase())).toList();

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Python Developer');
    });

    test('Filter by job type "Full-time" returns all full-time jobs', () {
      const jobType = 'Full-time';

      final filtered = mockJobs.where((job) => job.jobType == jobType).toList();

      expect(filtered.length, 2);
      expect(filtered.every((job) => job.jobType == 'Full-time'), isTrue);
    });

    test('Filter by job type "Internship" returns only internships', () {
      const jobType = 'Internship';

      final filtered = mockJobs.where((job) => job.jobType == jobType).toList();

      expect(filtered.length, 1);
      expect(filtered.first.jobType, 'Internship');
    });

    test('Filter by location "Cape Town" returns Cape Town jobs only', () {
      const selectedLocation = 'Cape Town';

      final filtered = mockJobs.where((job) =>
          job.location.toLowerCase().contains(selectedLocation.toLowerCase())).toList();

      expect(filtered.length, 1);
      expect(filtered.first.location, 'Cape Town');
    });

    test('Multiple filters work together', () {
      const selectedSkill = 'Flutter';
      const selectedLocation = 'Cape Town';

      var filtered = mockJobs.where((job) =>
          job.skills.any((skill) => skill.toLowerCase() == selectedSkill.toLowerCase())).toList();

      filtered = filtered.where((job) =>
          job.location.toLowerCase().contains(selectedLocation.toLowerCase())).toList();

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Flutter Developer');
    });

    test('Search by title returns matching jobs', () {
      final searchQuery = 'Flutter';

      final filtered = mockJobs.where((job) =>
          job.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Flutter Developer');
    });

    test('Search by company returns matching jobs', () {
      final searchQuery = 'Innovate';

      final filtered = mockJobs.where((job) =>
          job.company.toLowerCase().contains(searchQuery.toLowerCase())).toList();

      expect(filtered.length, 1);
      expect(filtered.first.company, 'Innovate SA');
    });

    test('Search by skill returns matching jobs', () {
      final searchQuery = 'Salesforce';

      final filtered = mockJobs.where((job) =>
          job.skills.any((skill) => skill.toLowerCase().contains(searchQuery.toLowerCase()))).toList();

      expect(filtered.length, 1);
      expect(filtered.first.title, 'Salesforce Intern');
    });

    test('Salary extraction returns correct max salary', () {
      const salaryRange = 'R18,000 – R25,000';

      final digits = RegExp(r'\d+').allMatches(salaryRange.replaceAll(',', ''));
      final maxSalary = digits.map((m) => int.parse(m.group(0)!)).reduce((a, b) => a > b ? a : b);

      expect(maxSalary, 25000);
    });
  });
}