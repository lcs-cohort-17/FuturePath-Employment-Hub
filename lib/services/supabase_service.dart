import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/training_programme.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() => _instance;

  SupabaseService._internal();

  final _client = Supabase.instance.client;

  // -------------------- GET ALL --------------------

  Future<List<TrainingProgramme>> getTrainingProgrammes() async {
    final response = await _client
        .from('training_programmes')
        .select();

    return (response as List)
        .map((json) => TrainingProgramme.fromJson(json))
        .toList();
  }

  // -------------------- GET BY ID --------------------

  Future<TrainingProgramme?> getTrainingProgrammeById(String id) async {
    final response = await _client
        .from('training_programmes')
        .select()
        .eq('programme_id', id)
        .maybeSingle();

    if (response == null) return null;

    return TrainingProgramme.fromJson(response);
  }

  // -------------------- CREATE --------------------

  Future<void> createTrainingProgramme(
      TrainingProgramme programme) async {
    await _client
        .from('training_programmes')
        .insert(programme.toJson());
  }

  // -------------------- UPDATE --------------------

  Future<void> updateTrainingProgramme(
      String id,
      TrainingProgramme programme,
      ) async {
    await _client
        .from('training_programmes')
        .update(programme.toJson())
        .eq('programme_id', id);
  }

  // -------------------- DELETE --------------------

  Future<void> deleteTrainingProgramme(String id) async {
    await _client
        .from('training_programmes')
        .delete()
        .eq('programme_id', id);
  }
}



// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../models/programme.dart';
// import '../models/employer.dart';
// import '../models/opportunity.dart';
// imp
//
// class SupabaseService {
//   static final SupabaseService _instance = SupabaseService._internal();
//   factory SupabaseService() => _instance;
//   SupabaseService._internal();
//
//   final SupabaseClient _client = Supabase.instance.client;
//
// // fetchTrainingProgrammes()
// // fetchEmploymentOpportunities()
// // fetchEmployers()
// }
//
// // class SupabaseService {
// //   static final SupabaseService _instance = SupabaseService._internal();
// //   factory SupabaseService() => _instance;
// //   SupabaseService._internal();
// //
// //   final SupabaseClient _client = Supabase.instance.client;
//
//   // -------------------- TRAINING PROGRAMMES --------------------
//   Future<List<TrainingProgramme>> fetchTrainingProgrammes() async {
//     final response = await _client
//         .from('training_programmes')
//         .select();
//
//     final data = response as List;
//
//     if (data.isEmpty) return [];
//
//     return data.map((item) {
//       return TrainingProgramme(
//         programmeId: item['programme_id'].toString(),
//         programmeName: item['programme_name'] ?? '',
//         programmeDescription: item['programme_description'] ?? '',
//         startDate: DateTime.parse(item['start_date']),
//         endDate: DateTime.parse(item['end_date']),
//         capacity: item['capacity'] ?? 0,
//         programmeStatus: item['programme_status'] ?? '',
//         requiredSkills: List<String>.from(item['required_skills'] ?? []),
//         programmeCategory: item['programme_category'] ?? '',
//       );
//     }).toList();
//   }
// }