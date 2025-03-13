import 'package:flutter/material.dart';

class DetailProgressIndicator extends StatelessWidget {
  final int index;
  final int percentage;
  const DetailProgressIndicator({
    super.key,
    required this.index,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'detail_progress_indicator_$index',
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0, end: percentage.toDouble()),
          builder: (context, animatedValue, child) {
            return Column(
              children: [
                LinearProgressIndicator(
                  value: animatedValue / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('${animatedValue.toInt()}%'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
