import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status colors dynamically
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'applied':
      case 'submitted':
        backgroundColor = const Color(0xFFEFF6FF); // Light Blue
        textColor = const Color(0xFF1D4ED8);
        break;
      case 'interviewing':
      case 'shortlisted':
        backgroundColor = const Color(0xFFFEF3C7); // Light Amber
        textColor = const Color(0xFFD97706);
        break;
      case 'accepted':
      case 'offered':
        backgroundColor = const Color(0xFFECFDF5); // Light Emerald
        textColor = const Color(0xFF047857);
        break;
      case 'rejected':
      case 'declined':
        backgroundColor = const Color(0xFFFEF2F2); // Light Red
        textColor = const Color(0xFFB91C1C);
        break;
      default:
        backgroundColor = const Color(0xFFF1F5F9); // Slate Grey fallback
        textColor = const Color(0xFF475569);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}