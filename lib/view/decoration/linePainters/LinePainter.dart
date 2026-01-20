import 'dart:ui';

import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:eyuunapp/view/decoration/linePainters/AbstractLinePainter.dart';

class LinePainter extends AbstractLinePainter {
  LinePainter(super.primaryLinePaint);

  @override
  /// Paints a top line of length [size.width]. The vertical size respected by [ArtDecoBoxDecoration] is [size.height] towards both inner and outer.
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint.from(primaryLinePaint)..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), linePaint);
  }

}