import 'package:animation_example/models/task.dart';
import 'package:animation_example/pages/card_detail/bloc/card_detail_bloc.dart';
import 'package:flutter/material.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final int? index;
  final Animation<double> animation;
  final void Function(int index) removeTask;
  final DetailBloc detailBloc;
  const TaskItemWidget({
    super.key,
    required this.task,
    this.index,
    required this.animation,
    required this.removeTask,
    required this.detailBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Column(
        children: [
          Row(
            children: [
              // Checkbox
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeColor: Colors.grey[400],

                  value: task.isCompleted,
                  onChanged: (value) {
                    detailBloc.add(
                      UpdateTaskStatus(task.copyWith(isCompleted: value)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Task title
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: task.isCompleted ? Colors.grey[500] : Colors.black87,
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: task.isCompleted ? Colors.grey[400] : null,
                    decorationThickness: task.isCompleted ? 2 : null,
                  ),
                ),
              ),
              // Delete button
              task.isCompleted
                  ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      if (index != null) {
                        removeTask(index!);
                      }
                    },
                  )
                  : const SizedBox(height: 40),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
