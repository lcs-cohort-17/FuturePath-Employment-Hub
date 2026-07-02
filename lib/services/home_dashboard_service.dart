import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/home/home_screen.dart';
import '../models/staff_job_model.dart';
import '../models/staff_programme_model.dart';

class HomeDashboardService {
  static final _supabase = Supabase.instance.client;

  static Future<HomeDashboardData> fetchDashboardData() async {
    try {
      final programmesCount = await _supabase.from('Training Programme').count(CountOption.exact);
      final jobsCount = await _supabase.from('Employment Opportunity').count(CountOption.exact);
      final employersCount = await _supabase.from('Employer').count(CountOption.exact);

      // ✅ Fetch jobs – only columns that exist
      final jobsRaw = await _supabase
          .from('Employment Opportunity')
          .select('''
            opportunity_id,
            opportunity_number,
            Position_Title,
            Position_Description,
            Required_Skills,
            Closing_Date,
            Opportunity_Status,
            Number_Of_Available_Positions,
            employer_id,
            Created_By
          ''')
          .eq('Opportunity_Status', 'open')
          .limit(3);

      final recommendedJobs = (jobsRaw as List).map((j) => StaffJobModel(
        opportunityId: j['opportunity_id'] ?? '',
        opportunityNumber: j['opportunity_number'],
        positionTitle: j['Position_Title'] ?? '',
        positionDescription: j['Position_Description'],
        requiredSkills: List<String>.from(j['Required_Skills'] ?? []),
        closingDate: j['Closing_Date'] != null ? DateTime.parse(j['Closing_Date']) : null,
        opportunityStatus: j['Opportunity_Status'] ?? 'open',
        numberAvailablePositions: j['Number_Of_Available_Positions'],
        employerId: j['employer_id'],
        createdBy: j['Created_By'],
        createdAt: null,      // not in table
        updatedAt: null,      // not in table
      )).toList();

      // Fetch featured programmes (keep as ProgrammeSummary)
      final programmesRaw = await _supabase
          .from('Training Programme')
          .select('''
            programme_id,
            Programme_Name,
            Programme_Status,
            category,
            level,
            duration_months,
            enrolled_count,
            Capacity
          ''')
          .limit(3);

      final featuredProgrammes = (programmesRaw as List).map((p) {
        final status = p['Programme_Status'] == 'open'
            ? ProgrammeStatus.open
            : p['Programme_Status'] == 'upcoming'
            ? ProgrammeStatus.startingSoon
            : ProgrammeStatus.closed;
        return ProgrammeSummary(
          id: p['programme_id'] ?? '',
          title: p['Programme_Name'] ?? '',
          provider: 'Provider', // join with provider table if needed
          duration: '${p['duration_months'] ?? 0} months',
          level: p['level'] ?? 'Beginner',
          enrolled: p['enrolled_count'] ?? 0,
          capacity: p['Capacity'] ?? 0,
          status: status,
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