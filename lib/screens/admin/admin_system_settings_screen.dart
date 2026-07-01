import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../core/widgets/loading_widget.dart';

class AdminSystemSettingsScreen extends StatefulWidget {
  const AdminSystemSettingsScreen({super.key});

  @override
  State<AdminSystemSettingsScreen> createState() =>
      _AdminSystemSettingsScreenState();
}

class _AdminSystemSettingsScreenState
    extends State<AdminSystemSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadSystemData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Loading system data...');
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadSystemData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE03A2F),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 4),
                  child: Text(
                    'System Settings',
                    style: TextStyle(
                      color: Color(0xFFF0EDE8),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Architecture & infrastructure overview',
                    style: const TextStyle(
                      color: Color(0xFF9E9B96),
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Development Environment Badge
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9EE8).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF4A9EE8).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A9EE8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Development Environment',
                              style: TextStyle(
                                color: Color(0xFF4A9EE8),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              provider.deployInfo ?? 'Last deploy: Today 08:45 · v0.9.2-beta',
                              style: const TextStyle(
                                color: Color(0xFF9E9B96),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // API Performance
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE03A2F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'API Performance',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                _SystemRow(
                  title: 'REST API response',
                  subtitle: 'Supabase PostgREST',
                  value: provider.restApiResponse ?? '142ms',
                  valueColor: const Color(0xFF2ECC8A),
                ),
                _SystemRow(
                  title: 'Auth API response',
                  subtitle: 'Supabase Auth',
                  value: provider.authApiResponse ?? '89ms',
                  valueColor: const Color(0xFF2ECC8A),
                ),
                _SystemRow(
                  title: 'Edge Function avg',
                  subtitle: 'Deno runtime',
                  value: provider.edgeFunctionAvg ?? '380ms',
                  valueColor: const Color(0xFFF5A623),
                ),

                const SizedBox(height: 8),

                // Database
                 Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE03A2F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Database',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                _SystemRow(
                  title: 'Active connections',
                  subtitle: 'PostgreSQL pool',
                  value: provider.activeConnections ?? '14/100',
                  valueColor: const Color(0xFFF0EDE8),
                ),
                _SystemRow(
                  title: 'DB size',
                  subtitle: 'Row count across tables',
                  value: provider.dbSize ?? '18.4 MB',
                  valueColor: const Color(0xFFF0EDE8),
                ),

                const SizedBox(height: 8),

                // Storage & Functions
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE03A2F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Storage & Functions',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                _SystemRow(
                  title: 'Storage used',
                  subtitle: 'CVs, images, docs',
                  value: provider.storageUsed ?? '2.4 GB',
                  valueColor: const Color(0xFF4A9EE8),
                ),
                _SystemRow(
                  title: 'Edge Functions',
                  subtitle: 'send-notification, etc.',
                  value: provider.edgeFunctionsStatus ?? '1 degraded',
                  valueColor: const Color(0xFFF5A623),
                ),
                _SystemRow(
                  title: 'Supabase status',
                  subtitle: 'status.supabase.com',
                  value: provider.supabaseStatus ?? 'Operational',
                  valueColor: const Color(0xFF2ECC8A),
                ),

                const SizedBox(height: 8),

                // App Info
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Color(0xFFE03A2F),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'App Info',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                _SystemRow(
                  title: 'Flutter SDK',
                  subtitle: 'supabase_flutter ^2.12.4',
                  value: provider.flutterSdk ?? '3.22.0',
                  valueColor: const Color(0xFF9E9B96),
                ),
                _SystemRow(
                  title: 'Build number',
                  subtitle: 'Internal version',
                  value: provider.buildNumber ?? 'v0.9.2',
                  valueColor: const Color(0xFF9E9B96),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SystemRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final Color valueColor;

  const _SystemRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFF0EDE8),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF9E9B96),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}