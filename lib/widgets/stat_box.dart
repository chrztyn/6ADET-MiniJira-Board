import 'package:flutter/material.dart';

class StatBox extends StatelessWidget {
  final String label;
  final int count;

  const StatBox({super.key, required this.label, required this.count});

  Color _getColor() {
    switch (label) {
      case 'To Do':
        return const Color(0xFF3B82F6);
      case 'In Progress':
        return const Color(0xFFF59E0B);
      case 'Done':
        return const Color(0xFF10B981);
      default:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (label) {
      case 'To Do':
        return Icons.pending_actions;
      case 'In Progress':
        return Icons.sync;
      case 'Done':
        return Icons.check_circle;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getColor().withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: _getColor().withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(_getIcon(), color: _getColor(), size: 28),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getColor(),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}