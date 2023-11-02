/*
import 'dart:math';

import 'package:flutter/material.dart';

Widget generateRandomAbstractImage() {

  // Generate random colors
  final backgroundColor = generateRandomHexColor();
  final shapeColor = generateRandomHexColor();
  final lineColor = generateRandomHexColor();

  // Create an abstract image with random colors
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor,
      shape: BoxShape.circle,
      border: Border.all(color: shapeColor, width: 4),
    ),
    child: CustomPaint(
      size: Size(100, 100),
      painter: RandomAbstractPainter(lineColor: lineColor),
    ),
  );
}

class RandomAbstractPainter extends CustomPainter {
  final Color lineColor;

  RandomAbstractPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw random abstract lines
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

Color generateRandomHexColor() {
  final random = Random();
  int color = random.nextInt(0xFFFFFF); // Generate a random 24-bit color value
  return Color(0xFF000000 | color); // Convert to Color object
}*/
