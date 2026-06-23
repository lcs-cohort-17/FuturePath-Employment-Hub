import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_services.dart';

/// Exposes the AuthService singleton to widgets via Riverpod.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});