import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'async_state.dart';
import '../utils/error_handler.dart';

class StaffDashboardService extends ChangeNotifier {
  final SupabaseClient _supabase;


  StaffDashboardService(this._supabase);

  AsyncState<Map<String, dynamic>> _stats = AsyncState.idle();
  AsyncState<List<dynamic>> _activity = AsyncState.idle();
  AsyncState<Map<String, dynamic>> _content = AsyncState.idle();

  AsyncState<Map<String, dynamic>> get stats => _stats;
  AsyncState<List<dynamic>> get activity => _activity;
  AsyncState<Map<String, dynamic>> get content => _content;

  Future<void> loadDashboard({
    required String companyId,
  }) async {
    _stats = AsyncState.loading();
    _activity = AsyncState.loading();
    _content = AsyncState.loading();
    notifyListeners();

    try {
      final payload = {'company_id': companyId};

      final statsResp = await _supabase.functions.invoke(
        'get_staff_dashboard_stats',
        body: payload,
      );

      final activityResp = await _supabase.functions.invoke(
        'get_staff_activity_log',
        body: payload,
      );

      final contentResp = await _supabase.functions.invoke(
        'get_staff_content',
        body: payload,
      );

      final statsData = (statsResp.data is Map<String, dynamic>)
          ? statsResp.data as Map<String, dynamic>
          : <String, dynamic>{'result': statsResp.data};

      final activityData = (activityResp.data is List)
          ? activityResp.data as List<dynamic>
          : <dynamic>[];

      final contentData = (contentResp.data is Map<String, dynamic>)
          ? contentResp.data as Map<String, dynamic>
          : <String, dynamic>{'result': contentResp.data};

      _stats = statsData.isEmpty
          ? AsyncState.empty()
          : AsyncState.success(statsData);

      _activity = activityData.isEmpty
          ? AsyncState.empty()
          : AsyncState.success(activityData);

      _content = contentData.isEmpty
          ? AsyncState.empty()
          : AsyncState.success(contentData);
    } catch (e) {
      final msg = AppErrorHandler.getUserFriendlyMessage(e);
      _stats = AsyncState.error(msg);
      _activity = AsyncState.error(msg);
      _content = AsyncState.error(msg);
    } finally {
      notifyListeners();
    }
  }
}
