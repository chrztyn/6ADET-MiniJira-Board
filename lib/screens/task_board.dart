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
      description: 'Users can’t login on mobile devices.',
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
      appBar: AppBar(title: Text('MiniJira Board')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatBox(label: 'To Do', count: counts['To Do']!),
              StatBox(label: 'In Progress', count: counts['In Progress']!),
              StatBox(label: 'Done', count: counts['Done']!),
            ],
          ),
          SizedBox(height: 16.0),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text('Total: $total'), Text('Done: $done'), Text('Remaining: $remaining')],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['All', 'High Priority', 'Done'].map((filter) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () => setState(() => currentFilter = filter),
                  child: Text(filter),
                  style: ElevatedButton.styleFrom(backgroundColor: currentFilter == filter ? Colors.blue : Colors.grey),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final originalIndex = tasks.indexOf(task);
                return TaskCard(
                  task: task,
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TaskFormScreen(task: task, onSave: (updatedTask) => _updateTask(originalIndex, updatedTask)),
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
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => TaskFormScreen(onSave: _addTask))),
        child: Icon(Icons.add),
      ),
    );
  }
}
