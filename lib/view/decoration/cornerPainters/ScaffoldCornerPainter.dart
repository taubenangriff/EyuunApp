import 'dart:math' as math;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:eyuunapp/view/decoration/cornerPainters/AbstractCornerPainter.dart';

class ScaffoldCornerPainter extends AbstractCornerPainter {
  final _mirrorDiag = Float64List.fromList([
    0, 1, 0, 0, // column 0
    1, 0, 0, 0, // column 1
    0, 0, 1, 0, // column 2
    0, 0, 0, 1 // column 3
  ]);

  ScaffoldCornerPainter(super.cornerPaint, {this.squareSize = 6});

  double squareSize;
  late final _squareOffset = _sin45 * squareSize;
  final _sin45 = sin(math.pi / 4);

  late final _strokePaint = Paint.from(primaryLinePaint)
    ..style = PaintingStyle.stroke;
  late final _strokeThickness = primaryLinePaint.strokeWidth;
  late final _thinPaint = Paint.from(_strokePaint)
    ..strokeWidth = _strokeThickness * 0.8;

  @override
  void paint(Canvas canvas, Size size) {
    var width = min(size.width, size.height);

    var bounds = Rect.fromLTWH(-width, -width, 2 * width, 2 * width);

    var lineLength = width;
    var lineStopPos = _sin45 * lineLength + _squareOffset;

    canvas.drawLine(
        const Offset(0, 0), Offset(lineStopPos, lineStopPos), _thinPaint);

    canvas.save();
    canvas.translate(_squareOffset, _squareOffset);
    canvas.drawArc(bounds, 0, math.pi / 2, false, _strokePaint);
    canvas.restore();

    canvas.save();
    _paintHalfcorner(canvas, size);
    canvas.transform(_mirrorDiag);
    _paintHalfcorner(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.translate(-_squareOffset, -_squareOffset);
    var rect = _getRect();
    canvas.rotate(pi / 4);
    canvas.drawRect(rect, _strokePaint);

    canvas.restore();
  }

  void _paintHalfcorner(Canvas canvas, Size size) {
    var width = min(size.width, size.height);
    canvas.drawLine(const Offset(0, 0), Offset(width, 0), _strokePaint);
    var doubleWidth = width * 2;
    var lineWidth = doubleWidth - _squareOffset;
    var lineOffset = Offset(cos(pi / 8) * width, sin(pi / 8) * width);
    canvas.save();
    canvas.translate(_squareOffset, _squareOffset);
    //22.5 degree line
    canvas.drawLine(const Offset(0, 0), lineOffset, _thinPaint);
    //thick inner line
    canvas.drawLine(const Offset(0, 0), Offset(lineWidth, 0), _strokePaint);

    //small rect inner
    canvas.translate(doubleWidth, 0);
    canvas.rotate(pi / 4);
    var rect = _getRect();
    canvas.drawRect(rect, _strokePaint);
    canvas.restore();

    canvas.save();
    canvas.translate(-_squareOffset, -_squareOffset);
    //thick outer linke
    canvas.drawLine(
        Offset(_squareOffset, 0), Offset(lineWidth, 0), _strokePaint);
    canvas.translate(doubleWidth, 0);
    canvas.rotate(pi / 4);
    canvas.drawRect(rect, _strokePaint);
    canvas.restore();
  }

  Rect _getRect() {
    return Rect.fromCenter(
        center: Offset(0, 0), width: squareSize, height: squareSize);
  }
}
