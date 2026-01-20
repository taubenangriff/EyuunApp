import 'dart:typed_data';

import 'package:eyuunapp/view/decoration/ArtDecoBoxDecoration.dart';
import 'package:flutter/cupertino.dart';

abstract class AbstractCornerPainter extends CustomPainter {
  static Float64List mirrorDiag = Float64List.fromList([
    0, 1, 0, 0, // column 0
    1, 0, 0, 0, // column 1
    0, 0, 1, 0, // column 2
    0, 0, 0, 1 // column 3
  ]);
  Paint primaryLinePaint;
  AbstractCornerPainter(this.primaryLinePaint);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;


  @override
  /// Paints a top left corner into an area of [size.width], [size.height]. The area respected by [ArtDecoBoxDecoration] is 2*[size.width], 2*[size.height], centered to the corner at (0, 0)
  void paint(Canvas canvas, Size size);
}