import 'package:flutter/material.dart';

class ProgressBar extends CustomPainter {
  final double progress;

  ProgressBar({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // background bar
    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(
      trackRRect,
      trackPaint,
    );

    // progress bar
    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      size.width * progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(
      progressRRect,
      progressPaint,
    );

    // thumb
    canvas.drawCircle(
      Offset(size.width * progress, size.height / 2),
      7.5,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
