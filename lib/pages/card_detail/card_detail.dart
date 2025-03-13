import 'package:animation_example/models/task.dart';
import 'package:animation_example/pages/card_detail/widgets/task_item.dart';
import 'package:animation_example/pages/new_task/new_task.dart';
import 'package:animation_example/pages/widgets/detail_progress.dart';
import 'package:animation_example/pages/widgets/detail_title.dart';
import 'package:animation_example/pages/widgets/more_button.dart';
import 'package:animation_example/pages/widgets/task_count.dart';
import 'package:animation_example/pages/widgets/task_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final int index;
  final String title;
  const DetailPage({super.key, required this.index, required this.title});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonSizeAnimation;

  late AnimationController _contentAnimationController;
  late Animation<double> _contentHeightAnimation;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Task> _tasks = [
    Task(title: 'Meet Clients'),
    Task(title: 'Design Sprint'),
    Task(title: 'Icon Set Design for Mobile App'),
    Task(title: 'HTML/CSS Study'),
    Task(title: 'Weekly Report'),
    Task(title: 'Design Meeting'),
    Task(title: 'Quick Prototyping'),
  ];

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (context, result) {
        _dismissPage(shouldPop: false);
      },

      child: Stack(
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
            body: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swipe down
                  _dismissPage();
                }
              },
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1.0),
                duration: Duration(milliseconds: 600),
                builder: (context, scale, child) {
                  return Material(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
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
                            TaskCountWidget(index: widget.index, taskCount: 12),
                            const SizedBox(height: 4),
                            // Task title
                            DetailTitleWidget(
                              index: widget.index,
                              title: widget.title,
                            ),
                            const SizedBox(height: 8),
                            // Progress indicator
                            DetailProgressIndicator(index: widget.index),
                            const SizedBox(height: 24),

                            // Tasks list
                            SizeTransition(
                              axisAlignment: 0.0,
                              sizeFactor: _contentHeightAnimation,
                              child: AnimatedList(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                key: _listKey,
                                initialItemCount: _tasks.length,
                                itemBuilder: (context, index, animation) {
                                  return TaskItemWidget(
                                    task: _tasks[index],
                                    index: index,
                                    animation: animation,
                                    removeTask: _removeTask,
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
                              _addTask(result);
                            }
                          });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addTask(Task newTask) {
    _tasks.insert(0, newTask);
    _listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _removeTask(int index) {
    Task removedTask = _tasks.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => TaskItemWidget(
        task: removedTask,
        animation: animation,
        removeTask: _removeTask,
      ),
      duration: const Duration(milliseconds: 500),
    );
  }
}
