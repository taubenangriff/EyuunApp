import 'dart:ui';

import 'package:eyuunapp/view/decoration/linePainters/AbstractLinePainter.dart';

class ThickThinThickLinePainter extends AbstractLinePainter {
  ThickThinThickLinePainter(super.primaryLinePaint);

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    var thinPaint = Paint.from(linePaint)
      ..strokeWidth = linePaint.strokeWidth * 0.6;
    var outset = size.height - linePaint.strokeWidth/2;

    canvas.drawLine(
        Offset(-1, -outset), Offset(size.width + 1, -outset), linePaint);
    canvas.drawLine(const Offset(-1, 0), Offset(size.width + 1, 0), thinPaint);
    canvas.drawLine(
        Offset(-1, outset), Offset(size.width + 1, outset), linePaint);
  }
}
