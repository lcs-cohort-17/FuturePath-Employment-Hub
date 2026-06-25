import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../router/app_router.dart';
import '../../services/auth_services.dart';

/// App-level authentication and password-recovery navigation coordinator.
///
/// AppGate stays mounted above MaterialApp. This is required so a Supabase
/// password-recovery event can be handled even after Login has been replaced
/// by Home or while the app is already open.
class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  final AuthService _authService = AuthService();

  StreamSubscription<AuthState>? _authSubscription;
  Timer? _initialSessionTimer;
  Timer? _startupFallbackTimer;

  bool _passwordRecoveryDetected = false;
  bool _navigationScheduled = false;
  bool _hasCompletedInitialNavigation = false;
  String? _pendingRoute;

  @override
  void initState() {
    super.initState();

    _authSubscription = _authService.authStateChanges.listen(
      _handleAuthState,
      onError: _handleAuthStreamError,
    );

    // Supabase normally emits initialSession immediately. This fallback keeps
    // startup from hanging if that event is delayed by the environment.
    _startupFallbackTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted ||
          _pendingRoute != null ||
          _hasCompletedInitialNavigation) {
        return;
      }

      _queueNavigation(
        _authService.isLoggedIn
            ? AppRouter.home
            : AppRouter.login,
      );
    });
  }

  void _handleAuthState(AuthState state) {
    if (!mounted) return;

    switch (state.event) {
      case AuthChangeEvent.passwordRecovery:
        _passwordRecoveryDetected = true;
        _initialSessionTimer?.cancel();
        _startupFallbackTimer?.cancel();
        _queueNavigation(AppRouter.resetPassword);
        return;

      case AuthChangeEvent.initialSession:
        _initialSessionTimer?.cancel();

        // A recovery link may emit initialSession shortly before
        // passwordRecovery. The brief delay prevents Home flashing first.
        _initialSessionTimer = Timer(
          const Duration(milliseconds: 400),
          () {
            if (!mounted || _passwordRecoveryDetected) return;

            _startupFallbackTimer?.cancel();

            _queueNavigation(
              state.session != null
                  ? AppRouter.home
                  : AppRouter.login,
            );
          },
        );
        return;

      // Login, logout, and password update perform their own required NAV
      // transitions. Ignoring their ordinary auth events prevents duplicate
      // routes and preserves NAV-005/NAV-009 stack behaviour.
      default:
        return;
    }
  }

  void _handleAuthStreamError(
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint('Supabase auth stream error: $error');
    debugPrintStack(stackTrace: stackTrace);

    if (!_hasCompletedInitialNavigation && _pendingRoute == null) {
      _queueNavigation(
        _authService.isLoggedIn
            ? AppRouter.home
            : AppRouter.login,
      );
    }
  }

  void _queueNavigation(String routeName) {
    // Password recovery takes priority over normal startup routing.
    if (_pendingRoute == AppRouter.resetPassword &&
        routeName != AppRouter.resetPassword) {
      return;
    }

    _pendingRoute = routeName;

    if (_navigationScheduled) return;
    _navigationScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationScheduled = false;

      if (!mounted) return;

      final targetRoute = _pendingRoute;
      final navigator = AppRouter.navigatorKey.currentState;

      if (targetRoute == null) return;

      if (navigator == null) {
        _queueNavigation(targetRoute);
        return;
      }

      _pendingRoute = null;
      _hasCompletedInitialNavigation = true;

      navigator.pushNamedAndRemoveUntil(
        targetRoute,
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _initialSessionTimer?.cancel();
    _startupFallbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppRouter.navigatorKey,
      title: 'FuturePath Employment Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouter.generateRoute,
      home: const _StartupScreen(),
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}