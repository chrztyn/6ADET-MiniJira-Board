import 'package:flutter/material.dart';

class PriorityBadge extends StatelessWidget {
  final String priority;

  PriorityBadge({required this.priority});

  Color _getColor() {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(color: _getColor(), borderRadius: BorderRadius.circular(12.0)),
      child: Text(
        priority,
        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
