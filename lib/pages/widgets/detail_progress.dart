import 'package:flutter/material.dart';

class DetailProgressIndicator extends StatelessWidget {
  final int index;
  const DetailProgressIndicator({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'detail_progress_indicator_$index',
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: 0.24,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
            ),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerRight, child: Text('24%')),
          ],
        ),
      ),
    );
  }
}
