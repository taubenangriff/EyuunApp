import 'dart:math' as math;
import 'dart:ui';

import 'package:eyuunapp/view/decoration/cornerPainters/AbstractCornerPainter.dart';

class ThickThinThickCornerPainter extends AbstractCornerPainter {
  ThickThinThickCornerPainter(super.cornerPaint);

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    var thinPaint = Paint.from(linePaint)..strokeWidth = linePaint.strokeWidth * 0.6;
    var widthOutset = size.width - linePaint.strokeWidth/2;
    var outset = size.height - linePaint.strokeWidth/2;

    //vertical thick line
    canvas.drawLine(Offset(widthOutset, -outset), Offset(widthOutset, size.height), linePaint);
    //horizontal thick line
    canvas.drawLine(Offset(-size.width, outset), Offset(widthOutset, outset), linePaint);
    canvas.drawLine(Offset(0,0), Offset(size.width, 0), thinPaint);
    canvas.drawLine(Offset(0,0), Offset(0, size.height), thinPaint);
  }
}
