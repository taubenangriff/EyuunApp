import 'dart:ui';

import 'package:eyuunapp/view/decoration/linePainters/AbstractLinePainter.dart';

class CrossLinePainter extends AbstractLinePainter {
  CrossLinePainter(super.primaryLinePaint);

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    var innerLineOffset = size.height - linePaint.strokeWidth / 2;
    var thirdWidth = size.width / 3 - 4 * innerLineOffset;

    var outerPaint = Paint.from(linePaint)
      ..strokeWidth = linePaint.strokeWidth * 0.5;

    canvas.drawLine(const Offset(-1, 0), Offset(size.width + 1, 0), outerPaint);

    canvas.drawLine(Offset(-1, -innerLineOffset),
        Offset(thirdWidth - innerLineOffset, -innerLineOffset), linePaint);
    canvas.drawLine(
        Offset(size.width - thirdWidth + innerLineOffset, -innerLineOffset),
        Offset(size.width, -innerLineOffset),
        linePaint);

    canvas.drawLine(
        Offset(thirdWidth + innerLineOffset, innerLineOffset),
        Offset(size.width - thirdWidth - innerLineOffset, innerLineOffset),
        linePaint);

    canvas.drawLine(Offset(thirdWidth - innerLineOffset, -innerLineOffset),
        Offset(thirdWidth + innerLineOffset, innerLineOffset), linePaint);
    canvas.drawLine(
        Offset(size.width - thirdWidth + innerLineOffset, -innerLineOffset),
        Offset(size.width - thirdWidth - innerLineOffset, innerLineOffset),
        linePaint);
  }
}
