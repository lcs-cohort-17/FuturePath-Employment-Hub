import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:futurepath_employment_hub/providers/user_profile_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserProfileNotifier CV persistence', () {
    test('stores the selected CV details in the profile state', () async {
      final notifier = UserProfileNotifier();
      final bytes = Uint8List.fromList([1, 2, 3]);

      notifier.updateCvFile('resume.pdf', bytes, null);

      expect(notifier.state.cvFileName, 'resume.pdf');
      expect(notifier.state.cvFileBytes, bytes);
    });
  });
}
