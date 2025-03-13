import 'package:animation_example/models/task.dart';
import 'package:equatable/equatable.dart';

class DetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateTaskStatus extends DetailEvent {
  final Task newTask;
  UpdateTaskStatus(this.newTask);
}

class AddNewTask extends DetailEvent {
  final Task newTask;
  AddNewTask(this.newTask);
}

class RemoveTask extends DetailEvent {
  final int index;
  RemoveTask(this.index);
}

class Reset extends DetailEvent {}
