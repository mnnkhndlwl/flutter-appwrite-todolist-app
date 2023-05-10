import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo/features/tasks/controller/task_controller.dart';
import 'package:todo/models/task_model.dart';

class TaskCard extends ConsumerWidget {
  final TaskModel task;
  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color priorityColor = _getPriorityColor(task.priority);
    return Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              color: priorityColor,
              child: Text(
                task.priority,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(task.description),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Created at: ${DateFormat('MM-dd-yyyy').format(task.createdAt)}',
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: const Text('Completed'),
                    value: task.isCompleted,
                    onChanged: (newValue) {
                      ref
                          .read(taskControllerProvider.notifier)
                          .updateTask(task, context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(taskControllerProvider.notifier)
                          .deleteTask(task, context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.yellow;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
