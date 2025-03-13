import 'package:animation_example/models/task.dart';

extension TaskListExtension on List<Task> {
  int get completedPercentage {
    if (isEmpty) return 0;

    int completedCount = where((task) => task.isCompleted).length;
    double percentage = (completedCount / length) * 100;

    return percentage.round();
  }
}
