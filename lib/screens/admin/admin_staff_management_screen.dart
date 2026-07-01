import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../core/widgets/loading_widget.dart';

class AdminStaffManagementScreen extends StatefulWidget {
  const AdminStaffManagementScreen({super.key});

  @override
  State<AdminStaffManagementScreen> createState() =>
      _AdminStaffManagementScreenState();
}

class _AdminStaffManagementScreenState
    extends State<AdminStaffManagementScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Active', 'Suspended'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadStaffData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget(message: 'Loading staff data...');
          }

          final filtered = provider.filteredStaff(_selectedFilter);

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Text(
                    'Staff Management',
                    style: TextStyle(
                      color: Color(0xFFF0EDE8),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Filter pills
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = filter == _selectedFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFE03A2F) : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFE03A2F)
                                      : const Color(0xFF2E2E2E),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF9E9B96),
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Pending requests count
                if (_selectedFilter == 'All' || _selectedFilter == 'Pending')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${provider.pendingCount} pending requests require action',
                      style: const TextStyle(
                        color: Color(0xFF9E9B96),
                        fontSize: 10,
                      ),
                    ),
                  ),

                // Section headers
                if (_selectedFilter == 'All' || _selectedFilter == 'Pending')
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Color(0xFFF5A623), size: 14),
                        SizedBox(width: 5),
                        Text(
                          'Pending Approval',
                          style: TextStyle(
                            color: Color(0xFFF5A623),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Staff items
                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'No staff found',
                        style: TextStyle(color: Color(0xFF5C5A57)),
                      ),
                    ),
                  )
                else
                  for (final staff in filtered)
                    _StaffItem(
                      name: staff['name'] ?? '',
                      company: staff['company'] ?? '',
                      email: staff['email'] ?? '',
                      status: staff['status'] ?? 'Pending',
                      registeredAt: staff['registeredAt'] ?? '',
                      isPending: staff['status'] == 'Pending',
                      onApprove: staff['status'] == 'Pending'
                          ? () => context.read<AdminProvider>().approveStaff(staff['id'])
                          : null,
                      onReject: staff['status'] == 'Pending'
                          ? () => context.read<AdminProvider>().rejectStaff(staff['id'])
                          : null,
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StaffItem extends StatelessWidget {
  final String name;
  final String company;
  final String email;
  final String status;
  final String registeredAt;
  final bool isPending;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _StaffItem({
    required this.name,
    required this.company,
    required this.email,
    required this.status,
    required this.registeredAt,
    required this.isPending,
    this.onApprove,
    this.onReject,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'Active':
        return const Color(0xFF2ECC8A);
      case 'Pending':
        return const Color(0xFFF5A623);
      case 'Suspended':
        return const Color(0xFFE03A2F);
      default:
        return const Color(0xFF9E9B96);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFFF0EDE8),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      company,
                      style: const TextStyle(
                        color: Color(0xFF9E9B96),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _getStatusColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9EE8).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Staff',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF4A9EE8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  email,
                  style: const TextStyle(
                    color: Color(0xFF5C5A57),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
            Text(
              registeredAt,
              style: const TextStyle(
                color: Color(0xFF5C5A57),
                fontSize: 9,
              ),
            ),
            if (isPending) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onApprove,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ECC8A).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: const Color(0xFF2ECC8A).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check, color: Color(0xFF2ECC8A), size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Approve',
                              style: TextStyle(
                                color: Color(0xFF2ECC8A),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: onReject,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE03A2F).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: const Color(0xFFE03A2F).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.close, color: Color(0xFFE03A2F), size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Reject',
                              style: TextStyle(
                                color: Color(0xFFE03A2F),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}