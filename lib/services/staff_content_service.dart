import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'async_state.dart';
import '../utils/error_handler.dart';

class StaffContentService extends ChangeNotifier {
  final SupabaseClient _supabase;

  StaffContentService(this._supabase);

  AsyncState<List<Map<String, dynamic>>> _jobs = AsyncState.idle();
  AsyncState<List<Map<String, dynamic>>> _programmes = AsyncState.idle();

  AsyncState<List<Map<String, dynamic>>> get jobs => _jobs;
  AsyncState<List<Map<String, dynamic>>> get programmes => _programmes;

  Future<void> fetchJobs({required String companyId}) async {
    _jobs = AsyncState.loading();
    notifyListeners();

    try {
      final res = await _supabase
          .from('jobs')
          .select('*')
          .eq('company_id', companyId)
          .order('created_at', ascending: false);

      final list = (res is List)
          ? List<Map<String, dynamic>>.from(res)
          : <Map<String, dynamic>>[];

      _jobs = list.isEmpty
          ? AsyncState.empty()
          : AsyncState.success(list);
    } catch (e) {
      _jobs = AsyncState.error(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchProgrammes({required String companyId}) async {
    _programmes = AsyncState.loading();
    notifyListeners();

    try {
      final res = await _supabase
          .from('programmes')
          .select('*')
          .eq('company_id', companyId)
          .order('created_at', ascending: false);

      final list = (res is List)
          ? List<Map<String, dynamic>>.from(res)
          : <Map<String, dynamic>>[];

      _programmes = list.isEmpty
          ? AsyncState.empty()
          : AsyncState.success(list);
    } catch (e) {
      _programmes = AsyncState.error(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> createJob({
    required String companyId,
    required String title,
    required String description,
    required String location,
  }) async {
    try {
      final res = await _supabase.from('jobs').insert({
        'company_id': companyId,
        'title': title,
        'description': description,
        'location': location,
      }).select();

      final list = (res is List)
          ? List<Map<String, dynamic>>.from(res)
          : <Map<String, dynamic>>[];

      if (list.isNotEmpty) {
        await fetchJobs(companyId: companyId);
      }
    } catch (e) {
      throw Exception(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    }
  }

  Future<void> updateJob({
    required String companyId,
    required String jobId,
    required Map<String, dynamic> patch,
  }) async {
    try {
      await _supabase
          .from('jobs')
          .update(patch)
          .eq('id', jobId)
          .eq('company_id', companyId);

      await fetchJobs(companyId: companyId);
    } catch (e) {
      throw Exception(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    }
  }

  Future<void> deleteJob({
    required String companyId,
    required String jobId,
  }) async {
    try {
      await _supabase
          .from('jobs')
          .delete()
          .eq('id', jobId)
          .eq('company_id', companyId);

      await fetchJobs(companyId: companyId);
    } catch (e) {
      throw Exception(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    }
  }

  Future<void> createProgramme({
    required String companyId,
    required String title,
    required String description,
  }) async {
    try {
      await _supabase.from('programmes').insert({
        'company_id': companyId,
        'title': title,
        'description': description,
      }).select();

      await fetchProgrammes(companyId: companyId);
    } catch (e) {
      throw Exception(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    }
  }

  Future<void> updateProgramme({
    required String companyId,
    required String programmeId,
    required Map<String, dynamic> patch,
  }) async {
    try {
      await _supabase
          .from('programmes')
          .update(patch)
          .eq('id', programmeId)
          .eq('company_id', companyId);

      await fetchProgrammes(companyId: companyId);
    } catch (e) {
      throw Exception(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    }
  }

  Future<void> deleteProgramme({
    required String companyId,
    required String programmeId,
  }) async {
    try {
      await _supabase
          .from('programmes')
          .delete()
          .eq('id', programmeId)
          .eq('company_id', companyId);

      await fetchProgrammes(companyId: companyId);
    } catch (e) {
      throw Exception(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    }
  }
}