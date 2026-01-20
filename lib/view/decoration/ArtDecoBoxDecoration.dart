import 'dart:math' as math;
import 'dart:typed_data';

import 'package:eyuunapp/view/decoration/cornerPainters/AbstractCornerPainter.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/FullCornerPainter.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/LineCornerPainter.dart';
import 'package:eyuunapp/view/decoration/cornerPainters/SplitFullCornerPainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/AbstractLinePainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/DoubleLinePainter.dart';
import 'package:eyuunapp/view/decoration/linePainters/LinePainter.dart';
import 'package:flutter/material.dart';

class ArtDecoBoxDecoration extends Decoration {
  ArtDecoBoxDecoration(
      {required this.paint,
      this.cornerSize = 0,
      AbstractCornerPainter Function(Paint)? cornerBuilder,
      AbstractLinePainter Function(Paint)? horizontalLineBuilder,
      AbstractLinePainter Function(Paint)? verticalLineBuilder,
      this.background})
      : cornerBuilder = cornerBuilder ?? ((p) => LineCornerPainter(p)),
        horizontalLineBuilder =
            horizontalLineBuilder ?? ((p) => LinePainter(p)),
        verticalLineBuilder = verticalLineBuilder ?? ((p) => LinePainter(p));

  final AbstractCornerPainter Function(Paint) cornerBuilder;
  final AbstractLinePainter Function(Paint) horizontalLineBuilder;
  final AbstractLinePainter Function(Paint) verticalLineBuilder;

  final double cornerSize;
  final Paint paint;
  final Color? background;

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _ArtDecoBoxDecorationPainter(cornerSize, paint, background,
        cornerBuilder, horizontalLineBuilder, verticalLineBuilder);
  }
}

class _ArtDecoBoxDecorationPainter extends BoxPainter {
  _ArtDecoBoxDecorationPainter(
      this.cornerSize,
      this.paintBrush,
      this.background,
      this.cornerBuilder,
      this.horizontalLineBuilder,
      this.verticalLineBuilder);

  final double cornerSize;
  final Paint paintBrush;
  final Color? background;
  final AbstractCornerPainter Function(Paint) cornerBuilder;
  final AbstractLinePainter Function(Paint) horizontalLineBuilder;
  final AbstractLinePainter Function(Paint) verticalLineBuilder;

  final mirrorX = Float64List.fromList([
    -1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
  ]);

  final mirrorY = Float64List.fromList([
    1,
    0,
    0,
    0,
    0,
    -1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
  ]);

  final mirrorXY = Float64List.fromList([
    -1,
    0,
    0,
    0,
    0,
    -1,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    1,
  ]);

  final paintColor = Colors.white;

  late Paint outerPaint = Paint()
    ..color = paintColor
    ..strokeWidth = paintBrush.strokeWidth;

  late final AbstractCornerPainter cornerPainter = cornerBuilder(outerPaint);
  late final AbstractLinePainter horizontalLinePainter = horizontalLineBuilder(outerPaint);
  late final AbstractLinePainter verticalLinePainter = verticalLineBuilder(outerPaint);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & (configuration.size ?? const Size(0, 0));

    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    double cornerDecoSize = cornerSize;
    double middleLineOffset = 0;
    if (background != null) {
      var backgroundPaint = Paint()
        ..color = background!
        ..style = PaintingStyle.fill;
      canvas.drawRect(bounds, backgroundPaint);
    }

    //add shadow
    var shadowPaint = Paint.from(outerPaint)
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withAlpha(150)
      ..strokeWidth = outerPaint.strokeWidth + 5
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(3));
    canvas.drawLine(bounds.topRight, bounds.topLeft, shadowPaint);
    canvas.drawLine(bounds.topRight, bounds.bottomRight, shadowPaint);
    canvas.drawLine(bounds.bottomRight, bounds.bottomLeft, shadowPaint);
    canvas.drawLine(bounds.topLeft, bounds.bottomLeft, shadowPaint);

    var clipRect = Rect.fromCenter(
        center: bounds.center,
        width: bounds.width + 2 * cornerDecoSize,
        height: bounds.height + 2 * cornerDecoSize);

    //save layer so shadow + background are not affected by brush overlay later on.
    canvas.saveLayer(clipRect, Paint());

    var horizontalSize =
        Size(bounds.size.width - 2 * cornerDecoSize, cornerDecoSize);
    var verticalSize =
        Size(bounds.size.height - 2 * cornerDecoSize, cornerDecoSize);

    var cornerDecoSizeDoubled = cornerDecoSize;
    var size = Size(cornerDecoSizeDoubled, cornerDecoSizeDoubled);
    canvas.save();
    //top left corner
    canvas.translate(bounds.topLeft.dx, bounds.topLeft.dy);
    cornerPainter.paint(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.translate(bounds.topRight.dx, bounds.topRight.dy);
    //top right corner
    canvas.transform(mirrorX);
    cornerPainter.paint(canvas, size);
    //right line
    canvas.rotate(math.pi / 2);
    canvas.restore();

    canvas.save();
    canvas.translate(bounds.bottomLeft.dx, bounds.bottomLeft.dy);
    canvas.transform(mirrorY);
    cornerPainter.paint(canvas, size);
    //left line
    canvas.rotate(math.pi / 2);
    canvas.restore();

    canvas.save();
    canvas.translate(bounds.bottomRight.dx, bounds.bottomRight.dy);
    canvas.transform(mirrorXY);
    cornerPainter.paint(canvas, size);
    canvas.restore();

    //top line
    canvas.save();
    canvas.translate(bounds.topLeft.dx + cornerDecoSize, bounds.topLeft.dy);
    horizontalLinePainter.paint(canvas, horizontalSize);
    canvas.restore();

    //bottom line;
    canvas.save();
    canvas.translate(
        bounds.bottomLeft.dx + cornerDecoSize, bounds.bottomLeft.dy);
    canvas.transform(mirrorY);
    horizontalLinePainter.paint(canvas, horizontalSize);
    canvas.restore();

    //right line
    canvas.save();
    canvas.translate(bounds.topRight.dx, bounds.topRight.dy + cornerDecoSize);
    canvas.rotate(math.pi / 2);
    verticalLinePainter.paint(canvas, verticalSize);
    canvas.restore();

    //left line
    canvas.save();
    canvas.translate(bounds.topLeft.dx, bounds.topLeft.dy + cornerDecoSize);
    canvas.transform(mirrorX);
    canvas.rotate(math.pi / 2);
    verticalLinePainter.paint(canvas, verticalSize);
    canvas.restore();

    var overlayPaint = paintBrush
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.srcIn;
    canvas.drawRect(clipRect, overlayPaint);
    canvas.restore();
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
