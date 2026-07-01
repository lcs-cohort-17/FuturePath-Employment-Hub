import '../models/employer.dart';
import '../models/employer_data.dart';

/// Service layer for employer CRUD operations.
///
/// Currently returns empty data so the UI renders with real empty/loading
/// states during development. Replace each method body with the corresponding
/// Supabase call when the backend is ready — the method signatures and return
/// types are intentionally final.
///
/// Expected Supabase table: `employers`
/// Required columns: id (uuid), company_name, industry, location,
///   contact_email, contact_phone, website, description, created_at.
class EmployerService {
  // [SUPABASE-CONNECT] Inject your Supabase client here, e.g.:
  // final SupabaseClient _client = Supabase.instance.client;

  /// Fetch all employers, ordered by company name ascending.
  ///
  /// Supabase equivalent:
  /// ```dart
  /// final rows = await _client
  ///     .from('employers')
  ///     .select()
  ///     .order('company_name', ascending: true);
  /// return (rows as List).map((r) => Employer.fromMap(r)).toList();
  /// ```
  Future<List<Employer>> fetchEmployers() async {
    // [SUPABASE-CONNECT] Replace with real Supabase fetch.
    await Future.delayed(const Duration(milliseconds: 400));
    return List.of(mockEmployers); // swap this line for the Supabase call
  }

  /// Create a new employer row and return the created [Employer].
  ///
  /// [payload] is the output of [AdminEmployerFormScreen] — it already uses
  /// snake_case column names matching the Supabase table.
  ///
  /// Supabase equivalent:
  /// ```dart
  /// final row = await _client
  ///     .from('employers')
  ///     .insert(payload)
  ///     .select()
  ///     .single();
  /// return Employer.fromMap(row);
  /// ```
  Future<Employer> createEmployer(Map<String, dynamic> payload) async {
    // [SUPABASE-CONNECT] Replace with real Supabase insert (see above).
    await Future.delayed(const Duration(milliseconds: 300));
    return Employer.fromMap({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'created_at': DateTime.now().toIso8601String(),
      ...payload,
    });
  }

  /// Update an existing employer row and return the updated [Employer].
  ///
  /// Supabase equivalent:
  /// ```dart
  /// final row = await _client
  ///     .from('employers')
  ///     .update(payload)
  ///     .eq('id', id)
  ///     .select()
  ///     .single();
  /// return Employer.fromMap(row);
  /// ```
  Future<Employer> updateEmployer(
      String id, Map<String, dynamic> payload) async {
    // [SUPABASE-CONNECT] Replace with real Supabase update (see above).
    await Future.delayed(const Duration(milliseconds: 300));
    return Employer.fromMap({
      'id': id,
      'created_at': DateTime.now().toIso8601String(),
      ...payload,
    });
  }

  /// Permanently delete an employer by [id].
  ///
  /// Supabase equivalent:
  /// ```dart
  /// await _client.from('employers').delete().eq('id', id);
  /// ```
  Future<void> deleteEmployer(String id) async {
    // [SUPABASE-CONNECT] Replace with real Supabase delete (see above).
    await Future.delayed(const Duration(milliseconds: 300));
  }
}