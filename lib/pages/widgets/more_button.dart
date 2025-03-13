import 'package:flutter/material.dart';

class MoreButton extends StatelessWidget {
  final int index;
  const MoreButton({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'more_button_$index',
      child: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.black54),
        onPressed: () {},
      ),
    );
  }
}
