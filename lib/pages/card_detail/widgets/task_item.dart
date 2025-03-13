import 'package:animation_example/models/task.dart';
import 'package:flutter/material.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final int? index;
  final Animation<double> animation;
  final void Function(int index) removeTask;
  const TaskItemWidget({
    super.key,
    required this.task,
    this.index,
    required this.animation,
    required this.removeTask,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            // Checkbox
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                value: false,
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 16),
            // Task title
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                if (index != null) {
                  removeTask(index!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
