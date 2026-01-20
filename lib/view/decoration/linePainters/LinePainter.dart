import 'dart:ui';

import 'package:eyuunapp/view/decoration/linePainters/AbstractLinePainter.dart';

class LinePainter extends AbstractLinePainter {
  LinePainter(super.primaryLinePaint);

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), linePaint);
  }

}