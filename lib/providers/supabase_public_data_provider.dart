import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/training_programme.dart';
import '../services/supabase_service.dart';

final supabaseServiceProvider = Provider<SupabaseService>((ref){
  return SupabaseService();
});

final trainingProgrammesProvider = FutureProvider<List<TrainingProgramme>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return await service.getTrainingProgrammes();
});

void refreshTrainingProgrammesProviders(WidgetRef ref) => ref.invalidate(trainingProgrammesProvider);

void refreshAllData(WidgetRef ref){
  refreshTrainingProgrammesProviders(ref);
}