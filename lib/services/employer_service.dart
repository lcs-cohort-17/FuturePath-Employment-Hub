import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/employer.dart';

/// Service layer for employer CRUD operations.
class EmployerService {
  final _client = Supabase.instance.client;

  /// Fetch all employers, ordered by company name ascending.
  Future<List<Employer>> fetchEmployers() async {
    try {
      final response = await _client
          .from('Employer')
          .select()
          .order('Company_Name', ascending: true);
      return List<Map<String, dynamic>>.from(response)
          .map((r) => Employer.fromMap(r))
          .toList();
    } catch (e) {
      print('❌ Error fetching employers: $e');
      return [];
    }
  }

  /// Create a new employer row and return the created [Employer].
  Future<Employer> createEmployer(Map<String, dynamic> payload) async {
    final row = await _client
        .from('Employer')
        .insert(payload)
        .select()
        .single();
    return Employer.fromMap(row);
  }

  /// Update an existing employer row and return the updated [Employer].
  Future<Employer> updateEmployer(
      String id, Map<String, dynamic> payload) async {
    final row = await _client
        .from('Employer')
        .update(payload)
        .eq('employer_id', id)
        .select()
        .single();
    return Employer.fromMap(row);
  }

  /// Permanently delete an employer by [id].
  Future<void> deleteEmployer(String id) async {
    await _client.from('Employer').delete().eq('employer_id', id);
  }
}