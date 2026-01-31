import 'package:flutter/material.dart';
import '../models/task.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TaskCard({required this.task, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(task.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
                    IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                PriorityBadge(priority: task.priority),
                SizedBox(width: 8.0),
                Text('Status: ${task.status}', style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 8.0),
            Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
