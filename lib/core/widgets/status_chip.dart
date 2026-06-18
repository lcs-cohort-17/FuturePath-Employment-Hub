import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status; // "Accepted" | "Under Review" | "Pending"

  const StatusChip({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Accepted':
        backgroundColor = const Color(0xFF008080).withOpacity(0.1);
        textColor = const Color(0xFF008080);
        break;
      case 'Under Review':
        backgroundColor = const Color(0xFFF59E0B).withOpacity(0.1);
        textColor = const Color(0xFFD97706);
        break;
      case 'Pending':
      default:
        backgroundColor = const Color(0xFF64748B).withOpacity(0.1);
        textColor = const Color(0xFF64748B);
        break;
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
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
