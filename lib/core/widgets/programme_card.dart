import 'package:flutter/material.dart';

class ProgrammeCard extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final String status;
  final String title;
  final String duration;
  final String level;
  final int enrolled;
  final int capacity;
  final String startDate;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProgrammeCard({
    super.key,
    required this.category,
    required this.categoryColor,
    required this.status,
    required this.title,
    required this.duration,
    required this.level,
    required this.enrolled,
    required this.capacity,
    required this.startDate,
    this.onEdit,
    this.onDelete,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'Active':
        return const Color(0xFF2ECC8A);
      case 'Upcoming':
        return const Color(0xFFF5A623);
      case 'Closed':
        return const Color(0xFFE03A2F);
      default:
        return const Color(0xFF9E9B96);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = capacity > 0 ? (enrolled / capacity) * 100 : 0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image area
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      category == 'Technology' ? Icons.devices :
                      category == 'Security' ? Icons.shield :
                      category == 'Marketing' ? Icons.campaign :
                      Icons.school,
                      color: Colors.white.withValues(alpha: 0.15),
                      size: 32,
                    ),
                  ),
                  Positioned(
                    top: 7,
                    left: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF0EDE8),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
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
                            '● $status',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF0EDE8),
                    ),
                  ),
                  Text(
                    '$duration · $level · $enrolled/$capacity enrolled',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9E9B96),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF242424),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: progress / 100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: progress > 90 ? const Color(0xFFE03A2F) : const Color(0xFFE03A2F),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        progress > 90 ? 'Almost full!' : '${progress.toInt()}% filled',
                        style: TextStyle(
                          fontSize: 9,
                          color: progress > 90 ? const Color(0xFFE03A2F) : const Color(0xFF5C5A57),
                        ),
                      ),
                      Text(
                        '$enrolled/$capacity',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF5C5A57),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        startDate,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF5C5A57),
                        ),
                      ),
                      Row(
                        children: [
                          if (onEdit != null)
                            GestureDetector(
                              onTap: onEdit,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF242424),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit, color: Color(0xFF9E9B96), size: 12),
                                    SizedBox(width: 4),
                                    Text('Edit', style: TextStyle(color: Color(0xFF9E9B96), fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          if (onDelete != null) ...[
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: onDelete,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE03A2F).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFFE03A2F).withValues(alpha: 0.2),
                                    width: 0.5,
                                  ),
                                ),
                                child: const Icon(Icons.delete_outline, color: Color(0xFFE03A2F), size: 16),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}