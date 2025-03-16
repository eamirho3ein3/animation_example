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

  final List<Task> _tasks;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  DetailBloc({required List<Task> initialTasks})
    : _tasks = List<Task>.from(initialTasks),
      super(DetailUninitialized()) {
    on<Reset>(_onReset);
    on<UpdateTaskStatus>(_onUpdateTaskStatus);
    on<AddNewTask>(_onAddNewTask);
    on<RemoveTask>(_onRemoveTask);
  }

  List<Task> get tasks => _tasks;

  void _onReset(Reset event, Emitter<DetailState> emit) async {
    emit(DetailReset());
  }

  void _onUpdateTaskStatus(
    UpdateTaskStatus event,
    Emitter<DetailState> emit,
  ) async {
    emit(DetailLoading());
    final index = _tasks.indexWhere(
      (element) => element.id == event.newTask.id,
    );
    _tasks[index] = event.newTask;

    emit(TaskStatusUpdated());
  }

  void _onAddNewTask(AddNewTask event, Emitter<DetailState> emit) async {
    emit(DetailLoading());
    _tasks.insert(0, event.newTask);
    listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 500),
    );

    emit(TasksUpdated());
  }

  void _onRemoveTask(RemoveTask event, Emitter<DetailState> emit) async {
    emit(DetailLoading());
    Task removedTask = _tasks.removeAt(event.index);
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
