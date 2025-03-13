import 'package:flutter/material.dart';

class TaskCountWidget extends StatelessWidget {
  final int index;
  final int taskCount;
  const TaskCountWidget({
    super.key,
    required this.index,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'task_count_$index',
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.grey, fontSize: 14),
        child: Row(children: [Text('$taskCount'), Text('Tasks')]),
      ),
    );
  }
}
