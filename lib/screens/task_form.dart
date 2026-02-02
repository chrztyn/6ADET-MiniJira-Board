import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskFormScreen({super.key, this.task, required this.onSave});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  String _priority = 'Low';
  String _status = 'To Do';

  int _charCount = 0;
  String _statusLabel = 'Safe';
  Color _counterColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? 'Low';
    _status = widget.task?.status ?? 'To Do';

    _updateCounter(_descriptionController.text);
    _descriptionController.addListener(() => _updateCounter(_descriptionController.text));
  }

  void _updateCounter(String text) {
    setState(() {
      _charCount = text.length;
      if (_charCount <= 40) {
        _statusLabel = 'Safe';
        _counterColor = Colors.green;
      } else if (_charCount <= 80) {
        _statusLabel = 'Warning';
        _counterColor = Colors.orange;
      } else if (_charCount <= 120) {
        _statusLabel = 'Danger';
        _counterColor = Colors.red;
      } else {
        _statusLabel = 'Error';
        _counterColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),

              const SizedBox(height: 16),

              // DESCRIPTION
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _counterColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          color: _counterColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Description is required';
                  if (value.length > 120) return 'Description too long!';
                  return null;
                },
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Characters: $_charCount / 120',
                  style: TextStyle(
                    color: _counterColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PRIORITY DROPDOWN (STYLED)
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['Low', 'Medium', 'High'].map((priority) {
                  Color color;
                  IconData icon;

                  switch (priority) {
                    case 'High':
                      color = const Color(0xFFEF4444);
                      icon = Icons.arrow_upward;
                      break;
                    case 'Medium':
                      color = const Color(0xFFF59E0B);
                      icon = Icons.remove;
                      break;
                    case 'Low':
                      color = const Color(0xFF10B981);
                      icon = Icons.arrow_downward;
                      break;
                    default:
                      color = Colors.grey;
                      icon = Icons.flag;
                  }

                  return DropdownMenuItem(
                    value: priority,
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          priority,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  prefixIcon: Icon(Icons.flag),
                ),
              ),

              const SizedBox(height: 16),

              // STATUS DROPDOWN (STYLED)
              DropdownButtonFormField<String>(
                value: _status,
                items: ['To Do', 'In Progress', 'Done'].map((status) {
                  Color color;
                  IconData icon;

                  switch (status) {
                    case 'To Do':
                      color = const Color(0xFF3B82F6);
                      icon = Icons.pending_actions;
                      break;
                    case 'In Progress':
                      color = const Color(0xFFF59E0B);
                      icon = Icons.sync;
                      break;
                    case 'Done':
                      color = const Color(0xFF10B981);
                      icon = Icons.check_circle;
                      break;
                    default:
                      color = Colors.grey;
                      icon = Icons.circle;
                  }

                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          status,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _status = value!),
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.track_changes),
                ),
              ),

              const SizedBox(height: 28),

              // BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _charCount > 120
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                Task newTask = Task(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  priority: _priority,
                                  status: _status,
                                );
                                widget.onSave(newTask);
                                Navigator.pop(context);
                              }
                            },
                      child: Text(isEditing ? 'Update' : 'Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
