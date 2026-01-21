import 'dart:ui';

import 'package:eyuunapp/view/decoration/linePainters/AbstractLinePainter.dart';

class DoubleLinePainter extends AbstractLinePainter {
  DoubleLinePainter(super.primaryLinePaint);

  @override
  void paint(Canvas canvas, Size size) {
    var innerLineOffset = size.height / 4;

    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), linePaint);
    var outerPaint = Paint.from(linePaint)
      ..strokeWidth = linePaint.strokeWidth * 0.5;
    canvas.drawLine(Offset(0, innerLineOffset),
        Offset(size.width, innerLineOffset), outerPaint);
  }
}
