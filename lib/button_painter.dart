import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonPainter extends CustomPainter {
  final bool isPressed;
  final double animationValue;
  final Color backgroundColor;

  ButtonPainter({
    this.isPressed = false,
    required this.animationValue,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.5,
      Paint()..color = backgroundColor,
    );
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.35,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 3
        ..style = isPressed ? PaintingStyle.fill : PaintingStyle.stroke,
    );

    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.5,
      Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
