import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final bool isAnimating;
  final double animatedValue;

  CirclePainter({
    this.isAnimating = true,
    this.animatedValue = 0.8,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (isAnimating) {
      double slowedOpacity = (1 - ((animatedValue - 0.6) / 0.4)).clamp(0, 1);

      canvas.drawCircle(
        size.center(Offset.zero).translate(0, size.height * 0.5).translate(0, -75),
        (size.height * 0.8) * animatedValue,
        Paint()
          ..color = Colors.yellow.withOpacity(slowedOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
