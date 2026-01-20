import 'dart:math' as math;
import 'dart:ui';

import 'package:eyuunapp/view/decoration/cornerPainters/AbstractCornerPainter.dart';

class FullCornerPainter extends AbstractCornerPainter {
  FullCornerPainter(super.cornerPaint);

  @override
  void paint(Canvas canvas, Size size) {
    var fillPaint = Paint.from(primaryLinePaint)..style = PaintingStyle.fill;
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;

    // TODO: implement paint
    var bounds = Rect.fromLTWH(
        -size.width, -size.height, 2*size.width, 2*size.height);
    canvas.drawArc(bounds, 0, math.pi / 2, true, fillPaint);
  }
}
