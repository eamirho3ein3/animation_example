import 'package:equatable/equatable.dart';

class DetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class DetailUninitialized extends DetailState {}

class DetailLoading extends DetailState {}

class DetailReset extends DetailState {}

class TaskStatusUpdated extends DetailState {}

class TasksUpdated extends DetailState {}
