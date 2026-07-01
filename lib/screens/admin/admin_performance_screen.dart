import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../core/widgets/loading_widget.dart';

class AdminPerformanceScreen extends StatefulWidget {
  const AdminPerformanceScreen({super.key});

  @override
  State<AdminPerformanceScreen> createState() => _AdminPerformanceScreenState();
}

class _AdminPerformanceScreenState extends State<AdminPerformanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadPerformanceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Loading performance data...');
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
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadPerformanceData(),
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
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Text(
                    'Content Performance',
                    style: TextStyle(
                      color: Color(0xFFF0EDE8),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Top 5 Most Applied Jobs
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
                        'Top 5 Most Applied Jobs',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                ...provider.topJobs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final job = entry.value;
                  final colors = [
                    const Color(0xFFE03A2F),
                    const Color(0xFF4A9EE8),
                    const Color(0xFF2ECC8A),
                    const Color(0xFFF5A623),
                    const Color(0xFF9E9B96),
                  ];
                  return _PerformanceBar(
                    title: job['title'] ?? '',
                    subtitle: job['company'] ?? '',
                    percentage: (job['percentage'] ?? 0).toDouble(),
                    color: colors[index % colors.length],
                  );
                }),

                const Divider(
                  color: Color(0xFF2E2E2E),
                  height: 30,
                  thickness: 0.5,
                ),

                // Top 5 Most Enrolled Programmes
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
                        'Top 5 Most Enrolled Programmes',
                        style: TextStyle(
                          color: Color(0xFFF0EDE8),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                ...provider.topProgrammes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final prog = entry.value;
                  final colors = [
                    const Color(0xFF4A9EE8),
                    const Color(0xFFE03A2F),
                    const Color(0xFF2ECC8A),
                    const Color(0xFFF5A623),
                    const Color(0xFF9E9B96),
                  ];
                  return _PerformanceBar(
                    title: prog['title'] ?? '',
                    subtitle: 'Completion rate',
                    percentage: (prog['percentage'] ?? 0).toDouble(),
                    color: colors[index % colors.length],
                  );
                }),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PerformanceBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final double percentage;
  final Color color;

  const _PerformanceBar({
    required this.title,
    required this.subtitle,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFF0EDE8),
                  fontSize: 11,
                ),
              ),
              Text(
                '${percentage.toInt()}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF9E9B96),
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF242424),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              widthFactor: (percentage / 100).toDouble(),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}