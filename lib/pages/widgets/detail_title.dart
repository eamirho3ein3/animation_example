import 'package:flutter/material.dart';

class DetailTitleWidget extends StatelessWidget {
  final int index;
  final String title;
  const DetailTitleWidget({
    super.key,
    required this.index,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'task_title_$index',
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        child: Text(title),
      ),
    );
  }
}
