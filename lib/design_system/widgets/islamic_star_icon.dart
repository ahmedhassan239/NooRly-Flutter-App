import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom 8-pointed Islamic star (Rub el-Hizb / Octagram) icon widget
/// This creates an Islamic star pattern by overlapping two squares rotated 45 degrees
class IslamicStarIcon extends StatelessWidget {
  const IslamicStarIcon({
    super.key,
    this.size = 24.0,
    this.color = Colors.black,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _IslamicStarPainter(color),
    );
  }
}

class _IslamicStarPainter extends CustomPainter {
  _IslamicStarPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4; // Inner radius for the star points

    // Create 8 points for the octagram
    final outerPoints = List<Offset>.generate(8, (i) {
      final angle = (2 * math.pi * i) / 8 - math.pi / 2; // Start from top
      return Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
    });

    final innerPoints = List<Offset>.generate(8, (i) {
      final angle = (2 * math.pi * i) / 8 - math.pi / 2 + math.pi / 8; // Offset by 22.5 degrees
      return Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
    });

    // Create the path for the 8-pointed star
    final path = Path();
    for (int i = 0; i < 8; i++) {
      if (i == 0) {
        path.moveTo(outerPoints[i].dx, outerPoints[i].dy);
      } else {
        path.lineTo(outerPoints[i].dx, outerPoints[i].dy);
      }
      path.lineTo(innerPoints[i].dx, innerPoints[i].dy);
    }
    path.close();

    // Draw the star with fill
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Optional: Add a border for more definition (like in the image)
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _IslamicStarPainter oldDelegate) =>
      oldDelegate.color != color;
}
