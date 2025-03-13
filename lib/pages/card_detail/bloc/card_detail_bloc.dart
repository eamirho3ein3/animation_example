import 'package:animation_example/models/task.dart';
import 'package:animation_example/pages/card_detail/bloc/card_detail_events.dart';
import 'package:animation_example/pages/card_detail/bloc/card_detail_states.dart';
import 'package:animation_example/pages/card_detail/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:animation_example/pages/card_detail/bloc/card_detail_events.dart';
export 'package:animation_example/pages/card_detail/bloc/card_detail_states.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  bool isLoading = false;
  bool isSearching = false;
  bool haveMoreData = true;

  final List<Task> tasks = [
    Task(id: '1', title: 'Meet Clients'),
    Task(id: '2', title: 'Design Sprint', isCompleted: true),
    Task(id: '3', title: 'Icon Set Design for Mobile App'),
    Task(id: '4', title: 'HTML/CSS Study'),
    Task(id: '5', title: 'Weekly Report'),
    Task(id: '6', title: 'Design Meeting'),
    Task(id: '7', title: 'Quick Prototyping'),
  ];

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  DetailBloc() : super(DetailUninitialized()) {
    on<Reset>(_onReset);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<AddNewTask>(_onAddNewTask);
    on<RemoveTask>(_onRemoveTask);
  }

  void _onReset(Reset event, Emitter<DetailState> emit) async {
    emit(DetailReset());
  }

  void _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<DetailState> emit,
  ) async {
    emit(DetailLoading());
    final index = tasks.indexWhere((element) => element.id == event.newTask.id);
    tasks[index] = event.newTask;

    emit(TaskStatusUpdated());
  }

  void _onAddNewTask(AddNewTask event, Emitter<DetailState> emit) async {
    emit(DetailLoading());
    tasks.insert(0, event.newTask);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 500),
    );

    emit(TasksUpdated());
  }

  void _onRemoveTask(RemoveTask event, Emitter<DetailState> emit) async {
    emit(DetailLoading());
    Task removedTask = tasks.removeAt(event.index);
    listKey.currentState?.removeItem(
      event.index,
      (context, animation) => TaskItemWidget(
        task: removedTask,
        animation: animation,
        removeTask: (index) {
          add(RemoveTask(index));
        },
        detailBloc: this,
      ),
      duration: const Duration(milliseconds: 500),
    );

    emit(TasksUpdated());
  }
}
