import 'package:animation_example/models/task.dart';
import 'package:animation_example/pages/card_detail/bloc/card_detail_bloc.dart';
import 'package:animation_example/pages/card_detail/widgets/task_item.dart';
import 'package:animation_example/pages/new_task/new_task.dart';
import 'package:animation_example/pages/widgets/detail_progress.dart';
import 'package:animation_example/pages/widgets/detail_title.dart';
import 'package:animation_example/pages/widgets/more_button.dart';
import 'package:animation_example/pages/widgets/task_count.dart';
import 'package:animation_example/pages/widgets/task_icon.dart';
import 'package:animation_example/services/extentions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatefulWidget {
  final int index;
  final String title;
  final List<Task> tasks;
  const DetailPage({
    super.key,
    required this.index,
    required this.title,
    required this.tasks,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonSizeAnimation;

  late AnimationController _contentAnimationController;
  late Animation<double> _contentHeightAnimation;

  final ScrollController _scrollController = ScrollController();

  DetailBloc? _detailBloc;

  @override
  void initState() {
    super.initState();

    // Setup animation controller for the FAB
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Create the size animation for the FAB
    _buttonSizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Setup squash effect animation controller
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Create the squash effect animation
    _contentHeightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Start FAB and the height animation when the page loads
    Future.delayed(const Duration(milliseconds: 600), () {
      _buttonAnimationController.forward();
      _contentAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _dismissPage({bool shouldPop = true}) {
    _contentAnimationController.reverse();
    _buttonAnimationController.reverse().then((_) {
      if (mounted && shouldPop) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailBloc>(
      create: (context) => DetailBloc(initialTasks: widget.tasks),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (context, result) {
          _dismissPage(shouldPop: false);
        },

        child: _manageState(),
      ),
    );
  }

  _manageState() {
    return BlocBuilder<DetailBloc, DetailState>(
      builder: (context, state) {
        _detailBloc = context.read<DetailBloc>();

        return _buildBody();
      },
    );
  }

  _buildBody() {
    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.7, end: 1.0),
          duration: Duration(milliseconds: 600),
          builder: (context, scale, child) {
            return Hero(
              tag: 'card_${widget.index}',
              child: Container(color: Colors.white),
            );
          },
        ),
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black54),
              onPressed: _dismissPage,
            ),
            actions: [MoreButton(index: widget.index)],
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification &&
                  notification.metrics.pixels <= 0 &&
                  notification.dragDetails != null &&
                  notification.dragDetails!.primaryDelta! > 10) {
                _dismissPage();
                return true;
              }
              return false;
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.7, end: 1.0),
              duration: Duration(milliseconds: 600),
              builder: (context, scale, child) {
                return Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          // Task icon
                          TaskIcon(icon: Icons.work, index: widget.index),
                          const SizedBox(height: 16),
                          // Task count
                          TaskCountWidget(
                            index: widget.index,
                            taskCount: _detailBloc!.tasks.length,
                          ),
                          const SizedBox(height: 4),
                          // Task title
                          DetailTitleWidget(
                            index: widget.index,
                            title: widget.title,
                          ),
                          const SizedBox(height: 8),
                          // Progress indicator
                          DetailProgressIndicator(
                            index: widget.index,
                            percentage: _detailBloc!.tasks.completedPercentage,
                          ),
                          const SizedBox(height: 24),

                          // Tasks list
                          SizeTransition(
                            axisAlignment: 0.0,
                            sizeFactor: _contentHeightAnimation,
                            child: AnimatedList(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              key: _detailBloc!.listKey,
                              initialItemCount: _detailBloc!.tasks.length,
                              itemBuilder: (context, index, animation) {
                                return TaskItemWidget(
                                  task: _detailBloc!.tasks[index],
                                  index: index,
                                  animation: animation,
                                  removeTask: (index) {
                                    _detailBloc!.add(RemoveTask(index));
                                  },
                                  detailBloc: _detailBloc!,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: AnimatedBuilder(
            animation: _buttonSizeAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _buttonSizeAnimation.value,
                child: FloatingActionButton(
                  heroTag: 'fab_button',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  backgroundColor: Colors.blue[400],
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) {
                              return NewTaskPage(
                                deviceSize: Size(
                                  MediaQuery.of(context).size.width,
                                  MediaQuery.of(context).size.height,
                                ),
                              );
                            },
                          ),
                        )
                        .then((result) {
                          if (result != null) {
                            _detailBloc!.add(AddNewTask(result));
                          }
                        });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
