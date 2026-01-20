import 'dart:ui';

import 'package:eyuunapp/view/decoration/linePainters/AbstractLinePainter.dart';

class DoubleLinePainter extends AbstractLinePainter {
  DoubleLinePainter(super.primaryLinePaint);

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), linePaint);
    var outerPaint = Paint.from(linePaint)..strokeWidth = linePaint.strokeWidth * 0.5;
    canvas.drawLine(Offset(size.width / 4, -6), Offset(size.width / 4 * 3, -6), outerPaint);
    canvas.drawLine(Offset(size.width / 4, 6), Offset(size.width / 4 * 3, 6), outerPaint);
  }

}