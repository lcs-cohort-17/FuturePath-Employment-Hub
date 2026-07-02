import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/home/home_screen.dart';

class HomeDashboardService {
  static final _supabase = Supabase.instance.client;

  static Future<HomeDashboardData> fetchDashboardData() async {
    try {
      final programmesCount = await _supabase.from('Training Programme').count(CountOption.exact);
      final jobsCount = await _supabase.from('Employment Opportunity').count(CountOption.exact);
      final employersCount = await _supabase.from('Employer').count(CountOption.exact);

      final recommendedJobsRaw = await _supabase
          .from('Employment Opportunity')
          .select('*, Employer(Company_Name)')
          .limit(3);

      final featuredProgrammesRaw = await _supabase
          .from('Training Programme')
          .select('*')
          .limit(3);

      final recommendedJobs = (recommendedJobsRaw as List).map((j) {
        final companyName = j['Employer']?['Company_Name'] ?? 'Unknown';
        return JobSummary(
          id: j['opportunity_id'],
          title: j['Position_Title'],
          company: companyName,
          companyInitials: companyName.isNotEmpty ? companyName[0].toUpperCase() : '?',
          skills: List<String>.from(j['Required_Skills'] ?? []),
          employmentType: 'Full-time', // Schema missing job type
          closingLabel: 'Closes ${j['Closing_Date']}',
        );
      }).toList();

      final featuredProgrammes = (featuredProgrammesRaw as List).map((p) {
        return ProgrammeSummary(
          id: p['programme_id'],
          title: p['Programme_Name'],
          provider: 'Provider', // Would need join or field
          duration: '${p['duration_months'] ?? 0} months',
          level: p['level'] ?? 'Beginner',
          enrolled: p['enrolled_count'] ?? 0,
          capacity: p['Capacity'] ?? 0,
          status: p['Programme_Status'] == 'open' ? ProgrammeStatus.open : ProgrammeStatus.closed,
        );
      }).toList();

      return HomeDashboardData(
        programmesCount: programmesCount,
        openJobsCount: jobsCount,
        employersCount: employersCount,
        recommendedJobs: recommendedJobs,
        featuredProgrammes: featuredProgrammes,
      );
    } catch (e) {
      print('❌ Error fetching home dashboard data: $e');
      return const HomeDashboardData(
        programmesCount: 0,
        openJobsCount: 0,
        employersCount: 0,
        recommendedJobs: [],
        featuredProgrammes: [],
      );
    }
  }
}
