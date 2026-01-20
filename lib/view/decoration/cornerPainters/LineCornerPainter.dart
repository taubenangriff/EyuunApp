import 'dart:math' as math;
import 'dart:ui';

import 'package:eyuunapp/view/decoration/cornerPainters/AbstractCornerPainter.dart';

class LineCornerPainter extends AbstractCornerPainter {
  LineCornerPainter(super.cornerPaint);

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), linePaint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), linePaint);
  }
}
