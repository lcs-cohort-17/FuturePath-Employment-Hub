// lib/core/widgets/skill_chip.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Reusable skill chip widget with optional remove functionality
class SkillChip extends StatelessWidget {
  final String label;
  final VoidCallback? onRemove;
  final bool showRemoveIcon;

  const SkillChip({
    super.key,
    required this.label,
    this.onRemove,
    this.showRemoveIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primary.withAlpha(38),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
          if (onRemove != null && showRemoveIcon) ...[
            const SizedBox(width: 4),
            InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(10),
              child: const Icon(
                Icons.close,
                size: 16,
                color: AppTheme.mutedText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}