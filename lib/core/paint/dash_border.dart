import 'package:flutter/material.dart';
import 'package:wheels_kart/core/constant/colors.dart';

class DashedBorderPainter extends CustomPainter {
  Color? color;
  DashedBorderPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color =
              color ??
              AppColors
                  .grey // Border color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    double dashWidth = 10, dashSpace = 10;

    // Draw dashed top border
    drawDashedLine(
      canvas,
      const Offset(0, 0),
      Offset(size.width, 0),
      dashWidth,
      dashSpace,
      paint,
    );
    // Draw dashed right border
    drawDashedLine(
      canvas,
      Offset(size.width, 0),
      Offset(size.width, size.height),
      dashWidth,
      dashSpace,
      paint,
    );
    // Draw dashed bottom border
    drawDashedLine(
      canvas,
      Offset(size.width, size.height),
      Offset(0, size.height),
      dashWidth,
      dashSpace,
      paint,
    );
    // Draw dashed left border
    drawDashedLine(
      canvas,
      Offset(0, size.height),
      const Offset(0, 0),
      dashWidth,
      dashSpace,
      paint,
    );
  }

  void drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    double dashWidth,
    double dashSpace,
    Paint paint,
  ) {
    double totalLength = (end - start).distance;
    double dx = (end.dx - start.dx) / totalLength;
    double dy = (end.dy - start.dy) / totalLength;

    double currentLength = 0;
    while (currentLength < totalLength) {
      double nextLength = currentLength + dashWidth;
      if (nextLength > totalLength) {
        nextLength = totalLength;
      }
      canvas.drawLine(
        Offset(start.dx + dx * currentLength, start.dy + dy * currentLength),
        Offset(start.dx + dx * nextLength, start.dy + dy * nextLength),
        paint,
      );
      currentLength = nextLength + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
