import 'package:flutter/material.dart';

class TaskIcon extends StatelessWidget {
  final int index;
  final IconData icon;
  const TaskIcon({super.key, required this.icon, required this.index});

  @override
  Widget build(BuildContext context) {
    final double iconSize = 18;
    return Hero(
      tag: 'task_icon_$index',
      child: Container(
        height: 24 + iconSize,
        width: 24 + iconSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.transparent,
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Center(child: Icon(icon, color: Colors.blue, size: iconSize)),
      ),
    );
  }
}
