import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';

import 'package:eyuunapp/view/decoration/cornerPainters/AbstractCornerPainter.dart';

class DoubleLineCornerPainter extends AbstractCornerPainter {
  bool fillCorner;
  DoubleLineCornerPainter(super.cornerPaint, {this.fillCorner = true});

  @override
  void paint(Canvas canvas, Size size) {
    var innerLineOffset = size.height / 4;

    var fillPaint = Paint.from(primaryLinePaint)..style = PaintingStyle.fill;
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    var thinPaint = Paint.from(linePaint)
      ..strokeWidth = linePaint.strokeWidth * 0.6;

    var strokeWidth = linePaint.strokeWidth / 2;
    var width = size.width;
    var offsetAngle = math.asin(innerLineOffset / width);
    var extraWidth = width - cos(offsetAngle) * width;

    var cornerBounds = Rect.fromCenter(
        center: Offset(-extraWidth / 2, -extraWidth / 2),
        width: 2 * (size.width + extraWidth),
        height: 2 * (size.height + extraWidth));
    canvas.drawArc(cornerBounds, offsetAngle, math.pi / 2 - 2 * offsetAngle,
        false, thinPaint);

    canvas.drawLine(Offset(size.width - innerLineOffset, 0),
        Offset(size.width, 0), linePaint);
    canvas.drawLine(Offset(0, size.height - innerLineOffset),
        Offset(0, size.height), linePaint);

    var thickCornerBounds = Rect.fromCenter(
        center: Offset(0, 0),
        width: 2 * (size.width - innerLineOffset),
        height: 2 * (size.height - innerLineOffset));
    canvas.drawArc(thickCornerBounds, 0, math.pi / 2, false, linePaint);

    if(fillCorner){
      var filledCornerBounds = Rect.fromCenter(
          center: Offset(-strokeWidth, -strokeWidth),
          width: 2 * (size.width - 2 * innerLineOffset + strokeWidth),
          height: 2 * (size.height - 2 * innerLineOffset + strokeWidth));
      canvas.drawArc(filledCornerBounds, 0, math.pi / 2, true, fillPaint);
    }
  }
}
