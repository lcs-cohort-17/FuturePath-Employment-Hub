// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-024
// ═══════════════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/notification_badge.dart';

// ---------------------------------------------------------------------------
// MOCK DATA — remove this block and replace with SupabaseService calls
// once the service layer is ready. See INTEGRATION NOTES at bottom of file.
// ---------------------------------------------------------------------------
class _MockSystemData {
  static const String environment = 'Development';
  static const String lastDeploy = 'Today 08:45';
  static const String version = 'v0.9.2-beta';

  // API Performance (milliseconds)
  static const int restApiMs = 142;
  static const int authApiMs = 89;
  static const int edgeFnMs = 380;

  // Database
  static const int dbActiveConnections = 14;
  static const int dbMaxConnections = 100;
  static const String dbSize = '18.4 MB';

  // Storage & Functions
  static const String storageUsed = '2.4 GB';
  static const int edgeFunctionCount = 6;
  static const int edgeFunctionsDegraded = 1;
  static const String supabaseStatus = 'Operational';

  // App Info
  static const String flutterSdk = '3.22.0';
  static const String supabaseFlutter = '^2.12.4';
  static const String buildNumber = 'v0.9.2';
}
// ---------------------------------------------------------------------------
// END MOCK DATA
// ---------------------------------------------------------------------------

class AdminSystemScreen extends StatefulWidget {
  const AdminSystemScreen({super.key});

  @override
  State<AdminSystemScreen> createState() => _AdminSystemScreenState();
}

class _AdminSystemScreenState extends State<AdminSystemScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  // Local state populated from mock (later: from SupabaseService)
  late _SystemSnapshot _snapshot;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ------------------------------------------------------------------
      // [SUPABASE-SYSTEM] — replace the simulated delay + mock assignment
      // below with a real SupabaseService.fetchSystemStatus() call once
      // the service layer is wired up.
      // ------------------------------------------------------------------
      await Future.delayed(const Duration(milliseconds: 600));

      _snapshot = _SystemSnapshot(
        environment: _MockSystemData.environment,
        lastDeploy: _MockSystemData.lastDeploy,
        version: _MockSystemData.version,
        restApiMs: _MockSystemData.restApiMs,
        authApiMs: _MockSystemData.authApiMs,
        edgeFnMs: _MockSystemData.edgeFnMs,
        dbActiveConnections: _MockSystemData.dbActiveConnections,
        dbMaxConnections: _MockSystemData.dbMaxConnections,
        dbSize: _MockSystemData.dbSize,
        storageUsed: _MockSystemData.storageUsed,
        edgeFunctionCount: _MockSystemData.edgeFunctionCount,
        edgeFunctionsDegraded: _MockSystemData.edgeFunctionsDegraded,
        supabaseStatus: _MockSystemData.supabaseStatus,
        flutterSdk: _MockSystemData.flutterSdk,
        supabaseFlutter: _MockSystemData.supabaseFlutter,
        buildNumber: _MockSystemData.buildNumber,
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load system data. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage != null
                  ? _buildErrorState()
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top Bar ─────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Brand mark
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(7),
            ),
            alignment: Alignment.center,
            child: const Text(
              'FP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            'System Settings',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const Spacer(),
          // Notification bell
          const NotificationBadge(),
        ],
      ),
    );
  }

  // ─── Loading State ────────────────────────────────────────────────────────

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primary,
            strokeWidth: 2,
          ),
          SizedBox(height: 16),
          Text(
            'Loading system data…',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.mutedText,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Error State ──────────────────────────────────────────────────────────

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppTheme.errorLow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_outlined,
                  color: AppTheme.error, size: 24),
            ),
            const SizedBox(height: 14),
            const Text(
              'Could not load system data',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _errorMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.mutedText,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _loadData,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Try again',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Main Content ─────────────────────────────────────────────────────────

  Widget _buildContent() {
    return RefreshIndicator(
      color: AppTheme.primary,
      backgroundColor: AppTheme.surface2,
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Text(
                'Architecture & infrastructure overview',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.mutedText,
                ),
              ),
            ),

            // 1 — Development Environment badge
            _buildEnvironmentBadge(),

            // 2 — API Performance
            _buildSectionHeader('API Performance'),
            _buildSystemRow(
              title: 'REST API response',
              subtitle: 'Supabase PostgREST',
              value: '${_snapshot.restApiMs}ms',
              valueColor: _latencyColor(_snapshot.restApiMs),
            ),
            _buildSystemRow(
              title: 'Auth API response',
              subtitle: 'Supabase Auth',
              value: '${_snapshot.authApiMs}ms',
              valueColor: _latencyColor(_snapshot.authApiMs),
            ),
            _buildSystemRow(
              title: 'Edge Function avg',
              subtitle: 'Deno runtime',
              value: '${_snapshot.edgeFnMs}ms',
              valueColor: _latencyColor(_snapshot.edgeFnMs),
            ),

            // 3 — Database
            _buildSectionHeader('Database'),
            _buildSystemRow(
              title: 'Active connections',
              subtitle: 'PostgreSQL pool',
              value:
              '${_snapshot.dbActiveConnections}/${_snapshot.dbMaxConnections}',
              valueColor: AppTheme.textDark,
            ),
            _buildSystemRow(
              title: 'DB size',
              subtitle: 'Row count across tables',
              value: _snapshot.dbSize,
              valueColor: AppTheme.textDark,
            ),

            // 4 — Storage & Functions
            _buildSectionHeader('Storage & Functions'),
            _buildSystemRow(
              title: 'Storage used',
              subtitle: 'CVs, images, docs',
              value: _snapshot.storageUsed,
              valueColor: AppTheme.info,
            ),
            _buildSystemRow(
              title: 'Edge Functions',
              subtitle:
              '${_snapshot.edgeFunctionCount} deployed · send-notification, etc.',
              value: _snapshot.edgeFunctionsDegraded > 0
                  ? '${_snapshot.edgeFunctionsDegraded} degraded'
                  : 'All healthy',
              valueColor: _snapshot.edgeFunctionsDegraded > 0
                  ? AppTheme.warning
                  : AppTheme.success,
            ),
            _buildSystemRow(
              title: 'Supabase status',
              subtitle: 'status.supabase.com',
              value: _snapshot.supabaseStatus,
              valueColor: _snapshot.supabaseStatus == 'Operational'
                  ? AppTheme.success
                  : AppTheme.warning,
            ),

            // 5 — App Info
            _buildSectionHeader('App Info'),
            _buildSystemRow(
              title: 'Flutter SDK',
              subtitle: 'supabase_flutter ${_snapshot.supabaseFlutter}',
              value: _snapshot.flutterSdk,
              valueColor: AppTheme.mutedText,
              valueFontSize: 11,
            ),
            _buildSystemRow(
              title: 'Build number',
              subtitle: 'Internal version',
              value: _snapshot.buildNumber,
              valueColor: AppTheme.mutedText,
              valueFontSize: 11,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Environment Badge ────────────────────────────────────────────────────

  Widget _buildEnvironmentBadge() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.infoLow,
        border: Border.all(
          color: AppTheme.info.withOpacity(0.2),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.info,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_snapshot.environment} Environment',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.info,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Last deploy: ${_snapshot.lastDeploy} · ${_snapshot.version}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section Header ───────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // ─── System Row ───────────────────────────────────────────────────────────

  Widget _buildSystemRow({
    required String title,
    required String subtitle,
    required String value,
    required Color valueColor,
    double valueFontSize = 13,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        border: Border.all(color: AppTheme.border, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Returns green for fast, amber for moderate, red for slow response times.
  Color _latencyColor(int ms) {
    if (ms < 200) return AppTheme.success;
    if (ms < 350) return AppTheme.warning;
    return AppTheme.primary; // primary doubles as error per theme.dart
  }
}

// ─── Data snapshot model ─────────────────────────────────────────────────────
// Lightweight local model — replace constructor call with SupabaseService
// response mapping when the service is ready.

class _SystemSnapshot {
  final String environment;
  final String lastDeploy;
  final String version;
  final int restApiMs;
  final int authApiMs;
  final int edgeFnMs;
  final int dbActiveConnections;
  final int dbMaxConnections;
  final String dbSize;
  final String storageUsed;
  final int edgeFunctionCount;
  final int edgeFunctionsDegraded;
  final String supabaseStatus;
  final String flutterSdk;
  final String supabaseFlutter;
  final String buildNumber;

  const _SystemSnapshot({
    required this.environment,
    required this.lastDeploy,
    required this.version,
    required this.restApiMs,
    required this.authApiMs,
    required this.edgeFnMs,
    required this.dbActiveConnections,
    required this.dbMaxConnections,
    required this.dbSize,
    required this.storageUsed,
    required this.edgeFunctionCount,
    required this.edgeFunctionsDegraded,
    required this.supabaseStatus,
    required this.flutterSdk,
    required this.supabaseFlutter,
    required this.buildNumber,
  });
}
// ═══════════════════════════════════════════════════════════════════════
// Lutfeeya-UIUX-024
// ═══════════════════════════════════════════════════════════════════════