import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskFormScreen({this.task, required this.onSave});

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
        _counterColor = Colors.yellow;
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
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
              ),
              SizedBox(height: 8.0),
              Text(
                'Characters: $_charCount / 120',
                style: TextStyle(color: _counterColor, fontWeight: FontWeight.bold),
              ),
              Text('Status: $_statusLabel', style: TextStyle(color: _counterColor)),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                initialValue: _priority,
                items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                initialValue: _status,
                items: ['To Do', 'In Progress', 'Done'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (value) => setState(() => _status = value!),
                decoration: InputDecoration(labelText: 'Status'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
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
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
