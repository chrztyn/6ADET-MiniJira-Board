import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/stat_box.dart';
import '../widgets/task_card.dart';
import 'task_form.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  List<Task> tasks = [
    Task(
      title: 'Fix login bug',
      description: 'Users cannot login on mobile devices.',
      priority: 'High',
      status: 'To Do',
    ),
    Task(
      title: 'Update UI spacing',
      description: 'Align header containers evenly across screens.',
      priority: 'Medium',
      status: 'In Progress',
    ),
    Task(
      title: 'Add user authentication',
      description: 'Implement OAuth for secure login.',
      priority: 'High',
      status: 'Done',
    ),
    Task(
      title: 'Optimize database queries',
      description: 'Reduce load times for large datasets.',
      priority: 'Low',
      status: 'To Do',
    ),
    Task(
      title: 'Write unit tests',
      description: 'Cover core functionality with tests.',
      priority: 'Medium',
      status: 'In Progress',
    ),
    Task(
      title: 'Deploy to production',
      description: 'Push latest build to live server.',
      priority: 'High',
      status: 'Done',
    ),
  ];

  String currentFilter = 'All';

  List<Task> getFilteredTasks() {
    if (currentFilter == 'All') return tasks;
    if (currentFilter == 'High Priority') return tasks.where((t) => t.priority == 'High').toList();
    if (currentFilter == 'Done') return tasks.where((t) => t.status == 'Done').toList();
    return tasks;
  }

  Map<String, int> getSummaryCounts() {
    int toDo = tasks.where((t) => t.status == 'To Do').length;
    int inProgress = tasks.where((t) => t.status == 'In Progress').length;
    int done = tasks.where((t) => t.status == 'Done').length;
    return {'To Do': toDo, 'In Progress': inProgress, 'Done': done};
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _updateTask(int index, Task updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var counts = getSummaryCounts();
    var filteredTasks = getFilteredTasks();
    int total = tasks.length;
    int done = counts['Done']!;
    int remaining = total - done;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MiniJira Board'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Stats Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatBox(label: 'To Do', count: counts['To Do']!),
                StatBox(label: 'In Progress', count: counts['In Progress']!),
                StatBox(label: 'Done', count: counts['Done']!),
              ],
            ),
          ),
          
          // Summary Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryItem('Total', '$total', Icons.list_alt),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.shade300,
                ),
                _buildSummaryItem('Done', '$done', Icons.check_circle),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.shade300,
                ),
                _buildSummaryItem('Remaining', '$remaining', Icons.pending),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['All', 'High Priority', 'Done'].map((filter) {
                bool isActive = currentFilter == filter;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () => setState(() => currentFilter = filter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive ? const Color(0xFF5B6CFF) : Colors.white,
                      foregroundColor: isActive ? Colors.white : Colors.grey.shade700,
                      elevation: isActive ? 2 : 0,
                      side: BorderSide(
                        color: isActive ? const Color(0xFF5B6CFF) : Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(filter),
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Task List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final originalIndex = tasks.indexOf(task);
                return TaskCard(
                  task: task,
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskFormScreen(
                        task: task,
                        onSave: (updatedTask) => _updateTask(originalIndex, updatedTask),
                      ),
                    ),
                  ),
                  onDelete: () => _deleteTask(originalIndex),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskFormScreen(onSave: _addTask),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF5B6CFF), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5B6CFF),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}