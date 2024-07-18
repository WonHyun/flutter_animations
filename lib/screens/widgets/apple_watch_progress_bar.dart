import 'package:flutter/material.dart';
import 'package:flutter_animations/screens/painter/apple_watch_painter.dart';

class AppleWatchProgressBar extends StatelessWidget {
  const AppleWatchProgressBar({
    super.key,
    required this.progress,
    this.size = 100,
    this.thickness = 25,
    this.barColor,
    this.backgroundBarColor,
  });

  final double progress;
  final double size;
  final double thickness;
  final Color? barColor;
  final Color? backgroundBarColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AppleWatchPainter(
        progress: progress,
        barColor: barColor ?? Colors.grey,
        backgroundBarColor: backgroundBarColor ?? Colors.grey.withOpacity(0.3),
        thickness: thickness,
      ),
      size: Size(size, size),
    );
  }
}
