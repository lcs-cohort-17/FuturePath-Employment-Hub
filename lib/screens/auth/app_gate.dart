import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent, AuthState;
import '../../services/auth_services.dart';
import '../../services/staff_registration_service.dart';
import '../home/home_screen.dart';
import '../auth/login_screen.dart';
import '../auth/reset_password_screen.dart';
import 'package:futurepath_employment_hub/core/theme/app_theme.dart';
import '../../providers/user_profile_provider.dart';
import '../shell/main_shell.dart';
import '../staff/staff_shell.dart';
import '../shell/admin_shell.dart';

/// The first widget the app mounts.
/// Routes to AppShell, StaffShell, AdminShell, or LoginScreen
/// based on the current auth state and user role.
class AppGate extends ConsumerStatefulWidget {
  const AppGate({super.key});

  @override
  ConsumerState<AppGate> createState() => _AppGateState();
}

class _AppGateState extends ConsumerState<AppGate> {
  final AuthService _auth = AuthService();

  // null  → still checking (show spinner)
  // false → no session (show Login)
  // true  → valid session (show appropriate Shell)
  bool? _hasSession;
  String? _role;

  // Flipped to true when a password-recovery deep-link is detected
  bool _isPasswordRecovery = false;

  @override
  void initState() {
    super.initState();
    _checkInitialSession();
    _listenToAuthChanges();
  }

  Future<void> _checkInitialSession() async {
    final loggedIn = _auth.isLoggedIn;
    if (loggedIn) {
      final user = _auth.currentUser;
      if (user != null) {
        // Fetch role and profile
        final profile = await StaffRegistrationService.checkUserRole(user.id);
        await ref.read(userProfileProvider.notifier).fetchProfile(user.id);
        if (mounted) {
          setState(() {
            _role = profile?['role'];
            _hasSession = true;
          });
        }
        return;
      }
    }
    
    if (mounted) {
      setState(() => _hasSession = loggedIn);
    }
  }

  void _listenToAuthChanges() {
    _auth.authStateChanges.listen((AuthState state) async {
      if (!mounted) return;

      final event = state.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        setState(() {
          _isPasswordRecovery = true;
          _hasSession = true;
        });
        return;
      }

      if (state.session != null) {
        final user = state.session!.user;
        final profile = await StaffRegistrationService.checkUserRole(user.id);
        await ref.read(userProfileProvider.notifier).fetchProfile(user.id);
        if (mounted) {
          setState(() {
            _isPasswordRecovery = false;
            _hasSession = true;
            _role = profile?['role'];
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isPasswordRecovery = false;
            _hasSession = false;
            _role = null;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasSession == null) {
      return const Scaffold(
        backgroundColor: AppTheme.surface,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primary,
          ),
        ),
      );
    }

    if (_isPasswordRecovery) {
      return const ResetPasswordScreen();
    }

    if (_hasSession == true) {
      if (_role == 'staff') {
        return const StaffShell();
      }
      if (_role == 'admin') {
        return const AdminShell();
      }
      return const AppShell();
    }

    return const LoginScreen();
  }
}
