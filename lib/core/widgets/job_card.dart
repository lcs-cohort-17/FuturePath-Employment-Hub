import 'package:flutter/material.dart';

enum BadgeType { active, pending, suspended }

class JobCard extends StatelessWidget {
  final String companyInitials;
  final Color companyColor;
  final String title;
  final String company;
  final List<String> tags;
  final String meta;
  final String badgeText;
  final BadgeType badgeType;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Widget? extra;

  const JobCard({
    super.key,
    required this.companyInitials,
    required this.companyColor,
    required this.title,
    required this.company,
    required this.tags,
    required this.meta,
    required this.badgeText,
    required this.badgeType,
    this.onEdit,
    this.onDelete,
    this.extra,
  });

  Color _getBadgeColor() {
    switch (badgeType) {
      case BadgeType.active:
        return const Color(0xFF2ECC8A);
      case BadgeType.pending:
        return const Color(0xFFF5A623);
      case BadgeType.suspended:
        return const Color(0xFFE03A2F);
    }
  }

  Color _getBadgeBackground() {
    switch (badgeType) {
      case BadgeType.active:
        return const Color(0xFF2ECC8A).withValues(alpha: 0.12);
      case BadgeType.pending:
        return const Color(0xFFF5A623).withValues(alpha: 0.12);
      case BadgeType.suspended:
        return const Color(0xFFE03A2F).withValues(alpha: 0.12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: companyColor,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text(
                        companyInitials,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF0EDE8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Column(
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
                        company,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9E9B96),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: _getBadgeBackground(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _getBadgeColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: _getBadgeColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 7),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF9E9B96),
                  ),
                ),
              )).toList(),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            meta,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF5C5A57),
            ),
          ),
          if (extra != null) extra!,
          if (onEdit != null || onDelete != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
        ],
      ),
    );
  }
}