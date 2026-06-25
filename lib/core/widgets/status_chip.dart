// lib/core/widgets/status_chip.dart

import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  Color _backgroundColor() {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'accepted':
      case 'successful':
        return Colors.green.shade100;

      case 'pending':
      case 'submitted':
      case 'reviewing':
        return Colors.orange.shade100;

      case 'rejected':
      case 'declined':
      case 'unsuccessful':
        return Colors.red.shade100;

      default:
        return Colors.grey.shade200;
    }
  }

  Color _textColor() {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'accepted':
      case 'successful':
        return Colors.green.shade800;

      case 'pending':
      case 'submitted':
      case 'reviewing':
        return Colors.orange.shade800;

      case 'rejected':
      case 'declined':
      case 'unsuccessful':
        return Colors.red.shade800;

      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status,
        style: TextStyle(
          color: _textColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: _backgroundColor(),
    );
  }
}