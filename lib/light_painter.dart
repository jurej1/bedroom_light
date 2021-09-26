import 'dart:math';

import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LightPainter extends CustomPainter {
  final bool isOn;
  final Paint _bulbPaint;
  final double strokeWidth;
  final Paint _basePaint;

  final double bulbWidth = 75;
  final double bulbHeight = 65;
  LightPainter({
    this.isOn = false,
    this.strokeWidth = 2,
    required Color onColor,
    required Color baseColor,
  })  : _bulbPaint = Paint()..color = onColor,
        _basePaint = Paint()..color = baseColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double lineHeight = size.height * 0.4;

    _drawLine(canvas, size, lineHeight);

    Offset threadUpperCenter = Offset(size.width * 0.5, lineHeight);
    Offset threadEndPoint = _drawThreads(canvas, threadUpperCenter).translate(0, strokeWidth * 0.5);
    _drawBulb(canvas, threadEndPoint);
  }

  void _drawBulb(Canvas canvas, Offset threadEndPoint) {
    Path bulbPath = _bulbPath(canvas, threadEndPoint);

    if (this.isOn) {
      canvas.drawPath(
        bulbPath,
        Paint()
          ..color = Colors.yellow
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.fill,
      );
    }
    canvas.drawPath(
      bulbPath,
      Paint()
        ..color = _basePaint.color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );

    Offset bulbCenter = threadEndPoint.translate(
      0,
      (bulbHeight * 0.55),
    );

    _drawArc(canvas, bulbCenter);
    _drawRays(canvas, bulbCenter);
  }

  void _drawRays(Canvas canvas, Offset bulbCenter) {
    final double innerRadius = 37;
    final double outerRadius = 50;

    for (double i = -pi / 3; i <= pi / 3; i += pi / 6) {
      canvas.drawLine(
        bulbCenter.translate(
          sin(i) * innerRadius,
          cos(i) * innerRadius,
        ),
        bulbCenter.translate(
          sin(i) * outerRadius,
          cos(i) * outerRadius,
        ),
        Paint()
          ..color = _basePaint.color
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawArc(Canvas canvas, Offset bulbCenter) {
    canvas.drawArc(
      Rect.fromCircle(center: bulbCenter, radius: bulbWidth * 0.27),
      pi,
      -(0.5 * pi),
      false,
      Paint()
        ..color = _basePaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  Path _bulbPath(Canvas canvas, Offset startPoint) {
    Offset upperCenterPoint = startPoint;

    final Offset upperLeftPoint = upperCenterPoint.translate(-(bulbWidth * 0.5), 0);

    Offset movingPoint = upperLeftPoint.translate(bulbWidth * 0.25, 0);
    Path _bulbPath = Path()..moveTo(movingPoint.dx, movingPoint.dy);

    _bulbPath.cubicTo(
      upperLeftPoint.dx + (bulbWidth * 0.25),
      upperLeftPoint.dy + (bulbHeight * 0.3),
      upperLeftPoint.dx + (bulbWidth * 0.125),
      upperLeftPoint.dy + (bulbHeight * 0.3),
      upperLeftPoint.dx + (bulbWidth * 0.125),
      upperLeftPoint.dy + (bulbHeight * 0.55),
    );

    _bulbPath.arcToPoint(
      Offset(
        upperLeftPoint.dx + (bulbWidth * 0.875),
        upperLeftPoint.dy + (bulbHeight * 0.55),
      ),
      radius: Radius.circular(20),
      clockwise: false,
    );

    _bulbPath.cubicTo(
      upperLeftPoint.dx + (bulbWidth * 0.875),
      upperLeftPoint.dy + (bulbHeight * 0.3),
      upperLeftPoint.dx + (bulbWidth * 0.75),
      upperLeftPoint.dy + (bulbHeight * 0.3),
      upperLeftPoint.dx + (bulbWidth * 0.75),
      upperLeftPoint.dy,
    );

    _bulbPath.close();

    return _bulbPath;
  }

  void _drawLine(Canvas canvas, Size size, double lineHeight) {
    Offset topCenter = Offset(size.width * 0.5, 0);

    final double leftX = topCenter.dx - (strokeWidth * 0.5);
    final double rightX = leftX + strokeWidth;
    canvas.drawRect(
      Rect.fromLTRB(
        leftX,
        topCenter.dy,
        rightX,
        lineHeight,
      ),
      _basePaint,
    );
  }

  Offset _drawThreads(Canvas canvas, Offset upperCenter) {
    Offset threadUpperCenter = upperCenter;

    double width = 30;
    double height = 10;
    double spacing = 3;
    for (int i = 0; i < 2; i++) {
      _drawThread(canvas, threadUpperCenter, width, height);
      threadUpperCenter = threadUpperCenter.translate(0, (height + spacing));
      width += 10;
    }

    return threadUpperCenter;
  }

  void _drawThread(Canvas canvas, Offset upperCenter, double width, double height) {
    final Offset center = upperCenter.translate(0, height * 0.5);

    final double left = center.dx - (width * 0.5);
    final double top = center.dy - height * 0.5;
    final double right = center.dx + (width * 0.5);
    final double bottom = center.dy + height * 0.5;

    Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            left,
            top,
            right,
            bottom,
          ),
          Radius.circular(height * 0.5),
        ),
      );

    if (!this.isOn) {
      path
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(
              left + 3,
              top + 3,
              right - 3,
              bottom - 3,
            ),
            Radius.circular(height * 0.5),
          ),
        )
        ..fillType = PathFillType.evenOdd;
    }

    canvas.drawPath(path, Paint()..color = _basePaint.color);

    // final double leftX = upperCenter.dx - (width * 0.5);
    // final double rightX = leftX + width;
    // final double upperY = upperCenter.dy + (strokeWidth * 0.5);
    // final double lowerY = upperCenter.dy + height - (strokeWidth * 0.5);
    // canvas.drawRRect(
    //   RRect.fromRectAndRadius(
    //     Rect.fromLTRB(
    //       leftX,
    //       upperY,
    //       rightX,
    //       lowerY,
    //     ),
    //     Radius.circular(height * 0.5),
    //   ),
    //   Paint()
    //     ..color = _basePaint.color
    //     ..style = isOn ? PaintingStyle.fill : PaintingStyle.stroke
    //     ..strokeWidth = strokeWidth,
    // );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
