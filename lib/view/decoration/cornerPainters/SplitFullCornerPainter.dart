import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';

import 'package:eyuunapp/view/decoration/cornerPainters/AbstractCornerPainter.dart';

class SplitFullCornerPainter extends AbstractCornerPainter {
  double outerOffset = 5;

  SplitFullCornerPainter(super.cornerPaint);

  @override
  void paint(Canvas canvas, Size size) {
    var fillPaint = Paint.from(primaryLinePaint)..style = PaintingStyle.fill;
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;

    var width = size.width;

    var bounds = Rect.fromLTWH(
        -size.width, -size.height, 2* size.width, 2* size.height);
    var innerBounds = Rect.fromLTWH(
        -(size.width)  + outerOffset,
        -(size.height ) + outerOffset,
        2*size.width - 2 * outerOffset,
        2*size.height - 2 * outerOffset);

    canvas.drawArc(innerBounds, 0, math.pi / 2, true, fillPaint);
    canvas.drawArc(bounds, 0, math.pi / 2, false, linePaint);
  }
}
