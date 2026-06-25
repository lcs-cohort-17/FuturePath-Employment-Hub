import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'async_state.dart';
import '../utils/error_handler.dart';

class StaffRegistrationService extends ChangeNotifier {
  final SupabaseClient _supabase;

  StaffRegistrationService(this._supabase);

  AsyncState<Map<String, dynamic>> _state = AsyncState.idle();
  AsyncState<Map<String, dynamic>> get state => _state;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String companyId,
  }) async {
    _state = AsyncState.loading();
    notifyListeners();

    try {
      final response = await _supabase.functions.invoke(
        'register_staff_account',
        body: {
          'email': email,
          'password': password,
          'full_name': fullName,
          'company_id': companyId,
        },
      );

      final data = (response.data is Map<String, dynamic>)
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{'result': response.data};

      if (data.isEmpty) {
        _state = AsyncState.empty();
      } else {
        _state = AsyncState.success(data);
      }
    } catch (e) {
      _state = AsyncState.error(
        AppErrorHandler.getUserFriendlyMessage(e),
      );
    } finally {
      notifyListeners();
    }
  }
}