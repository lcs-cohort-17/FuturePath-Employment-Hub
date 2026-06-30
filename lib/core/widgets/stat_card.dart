import 'package:flutter/material.dart';

enum StatCardColor { neutral, green, red, blue }

class StatCard extends StatelessWidget {
  final String number;
  final String label;
  final StatCardColor color;

  const StatCard({
    super.key,
    required this.number,
    required this.label,
    this.color = StatCardColor.neutral,
  });

  Color _getNumberColor() {
    switch (color) {
      case StatCardColor.green:
        return const Color(0xFF2ECC8A);
      case StatCardColor.red:
        return const Color(0xFFE03A2F);
      case StatCardColor.blue:
        return const Color(0xFF4A9EE8);
      default:
        return const Color(0xFFF0EDE8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2E2E2E), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _getNumberColor(),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9E9B96),
            ),
          ),
        ],
      ),
    );
  }
}