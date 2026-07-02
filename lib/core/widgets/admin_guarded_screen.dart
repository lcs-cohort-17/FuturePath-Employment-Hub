import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/admin_guard.dart';

/// Wraps an admin-only screen with an async AdminGuard check.
///
/// Shows a loading spinner while the role check runs, then either
/// renders [child] (if the user is an authenticated admin) or a blank
/// screen while AdminGuard's scheduled redirect (to Login or Home) fires.
class AdminGuardedScreen extends ConsumerStatefulWidget {
  final Widget child;

  const AdminGuardedScreen({super.key, required this.child});

  @override
  ConsumerState<AdminGuardedScreen> createState() =>
      _AdminGuardedScreenState();
}

class _AdminGuardedScreenState extends ConsumerState<AdminGuardedScreen> {
  bool _checking = true;
  bool _allowed = false;

  @override
  void initState() {
    super.initState();
    _runCheck();
  }

  Future<void> _runCheck() async {
    final allowed = await AdminGuard.checkAdminAccess(context, ref);
    if (!mounted) return;
    setState(() {
      _allowed = allowed;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_allowed) {
      // AdminGuard has already scheduled a redirect; show blank until it fires.
      return const Scaffold(body: SizedBox.shrink());
    }
    return widget.child;
  }
}