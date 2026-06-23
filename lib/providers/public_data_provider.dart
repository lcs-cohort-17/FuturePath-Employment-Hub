import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:googleapis/connectors/v1.dart';
import '../services/google_sheets_service.dart';
import '../models/programme.dart';
import '../models/employer.dart';
import '../models/opportunity.dart';

// ---------- SERVICE PROVIDER (SINGLETON) ----------
// Provides a single instance of GoogleSheetsService to the whole app.
final googleSheetsServiceProvider = Provider<GoogleSheetsService>((ref) {
  return GoogleSheetsService(); // uses the singleton pattern internally
});

// ---------- READ PROVIDERS (FUTURE PROVIDERS) ----------
// Each fetches data from the service and caches it until invalidated.

final programmesProvider = FutureProvider<List<Programme>>((ref) async {
  final service = ref.read(googleSheetsServiceProvider);
  return await service.fetchProgrammes();
});

final opportunitiesProvider = FutureProvider<List<Opportunity>>((ref) async {
  final service = ref.read(googleSheetsServiceProvider);
  return await service.fetchOpportunities();
});

final employersProvider = FutureProvider<List<Employer>>((ref) async {
  final service = ref.read(googleSheetsServiceProvider);
  return await service.fetchEmployers();
});

// ---------- REFRESH FUNCTIONS ----------
// Call these after any Create/Update/Delete operation to reload the data.
// They invalidate the provider, so the next watch will trigger a new fetch.

void refreshProgrammes(WidgetRef ref) => ref.invalidate(programmesProvider);
void refreshOpportunities(WidgetRef ref) => ref.invalidate(opportunitiesProvider);
void refreshEmployers(WidgetRef ref) => ref.invalidate(employersProvider);

// Optional: refresh all at once
void refreshAllData(WidgetRef ref) {
  refreshProgrammes(ref);
  refreshOpportunities(ref);
  refreshEmployers(ref);
}