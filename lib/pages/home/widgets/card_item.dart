import 'package:animation_example/models/task.dart';
import 'package:animation_example/pages/card_detail/card_detail.dart';
import 'package:animation_example/pages/widgets/detail_progress.dart';
import 'package:animation_example/pages/widgets/detail_title.dart';
import 'package:animation_example/pages/widgets/more_button.dart';
import 'package:animation_example/pages/widgets/task_count.dart';
import 'package:animation_example/pages/widgets/task_icon.dart';
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final int index;
  final String title;
  final int progress;
  final bool isSelected;
  final List<Task> tasks;

  const CardItem({
    super.key,
    required this.index,
    required this.title,
    required this.progress,
    required this.tasks,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetailPage(context),
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swipe up to navigate to the detail page
          _navigateToDetailPage(context);
        }
      },
      child: Stack(
        children: [
          Hero(
            tag: 'card_$index',
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Task Icon
                        TaskIcon(
                          index: index,
                          icon:
                              index == 0
                                  ? Icons.work
                                  : (index == 1 ? Icons.home : Icons.person),
                        ),
                        // More Button
                        MoreButton(index: index),
                      ],
                    ),
                    const Spacer(),
                    // Task Count
                    TaskCountWidget(index: index, taskCount: tasks.length),
                    const SizedBox(height: 5),
                    // Task Title
                    DetailTitleWidget(index: index, title: title),
                    const SizedBox(height: 10),
                    // Progress Indicator
                    DetailProgressIndicator(index: index, percentage: progress),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                DetailPage(index: index, title: title, tasks: tasks),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
