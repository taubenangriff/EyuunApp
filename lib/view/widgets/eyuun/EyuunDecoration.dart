import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'Brushes.dart';

class EyuunDecoration extends Decoration {
  EyuunDecoration({required this.paint, this.cornerSize = 0, this.paintInnerLine = true, this.fillCorners = true});

  final double cornerSize;
  final Paint paint;
  final bool paintInnerLine;
  final bool fillCorners;

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _EyuunDecorationPainter(cornerSize, paint, paintInnerLine, fillCorners);
  }
}

class _EyuunDecorationPainter extends BoxPainter {
  _EyuunDecorationPainter(this.cornerSize, this.paintBrush, this.paintInnerLine, this.fillCorners);

  final double cornerSize;
  final Paint paintBrush;
  final bool paintInnerLine;
  final bool fillCorners;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & (configuration.size ?? const Size(0, 0));

    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    Paint innerPaint = Paint.from(paintBrush)..strokeWidth = 0.8;
    Paint cornerPaint =  Paint.from(paintBrush)..style = PaintingStyle.fill;
    Paint outerPaint = Paint.from(paintBrush)..strokeWidth = 1.5;

    double cornerDecoSize = cornerSize;
    double linesOffset = 4;
    double middleLineOffset = 1;
    double innerLineOffset = 5;

    var thetaOuter = middleLineOffset / cornerDecoSize;
    var circleLengthOuter = math.pi / 2 - 2 * thetaOuter;

    // outer Line
    var topLeftStartOuter =
        bounds.topLeft + Offset(cornerDecoSize, middleLineOffset);
    var topLeftEndOuter =
        bounds.topLeft + Offset(middleLineOffset, cornerDecoSize);
    var topRightStartOuter =
        bounds.topRight + Offset(-cornerDecoSize, middleLineOffset);
    var topRightEndOuter =
        bounds.topRight + Offset(-middleLineOffset, cornerDecoSize);
    var botLeftStartOuter =
        bounds.bottomLeft + Offset(cornerDecoSize, -middleLineOffset);
    var botLeftEndOuter =
        bounds.bottomLeft + Offset(middleLineOffset, -cornerDecoSize);
    var botRightStartOuter =
        bounds.bottomRight + Offset(-middleLineOffset, -cornerDecoSize);
    var botRightEndOuter =
        bounds.bottomRight + Offset(-cornerDecoSize, -middleLineOffset);

    canvas.drawLine(topLeftStartOuter, topRightStartOuter, outerPaint);
    canvas.drawLine(topRightEndOuter, botRightStartOuter, outerPaint);
    canvas.drawLine(botRightEndOuter, botLeftStartOuter, outerPaint);
    canvas.drawLine(botLeftEndOuter, topLeftEndOuter, outerPaint);

    var cornerDecoSizeDoubled = cornerDecoSize * 2;

    canvas.drawArc(
        Rect.fromLTWH(bounds.left - cornerDecoSize, bounds.top - cornerDecoSize,
            cornerDecoSizeDoubled, cornerDecoSizeDoubled),
        thetaOuter,
        circleLengthOuter,
        false,
        outerPaint);
    canvas.drawArc(
        Rect.fromLTWH(
            bounds.left - cornerDecoSize,
            bounds.bottom - cornerDecoSize,
            cornerDecoSizeDoubled,
            cornerDecoSizeDoubled),
        math.pi * 1.5 + thetaOuter,
        circleLengthOuter,
        false,
        outerPaint);
    canvas.drawArc(
        Rect.fromLTWH(
            bounds.right - cornerDecoSize,
            bounds.bottom - cornerDecoSize,
            cornerDecoSizeDoubled,
            cornerDecoSizeDoubled),
        math.pi + thetaOuter,
        circleLengthOuter,
        false,
        outerPaint);
    canvas.drawArc(
        Rect.fromLTWH(
            bounds.right - cornerDecoSize,
            bounds.top - cornerDecoSize,
            cornerDecoSizeDoubled,
            cornerDecoSizeDoubled),
        math.pi / 2 + thetaOuter,
        circleLengthOuter,
        false,
        outerPaint);

    if(paintInnerLine){
      var cornerDecoInnerSize = cornerDecoSize + innerLineOffset;
      var cornerDecoInnerSizeWithOffset = cornerDecoInnerSize - 1;
      //inner Line
      var topLeftStartInner =
          bounds.topLeft + Offset(cornerDecoInnerSizeWithOffset, innerLineOffset);
      var topLeftEndInner =
          bounds.topLeft + Offset(innerLineOffset, cornerDecoInnerSizeWithOffset);
      var topRightStartInner = bounds.topRight +
          Offset(-cornerDecoInnerSizeWithOffset, innerLineOffset);
      var topRightEndInner = bounds.topRight +
          Offset(-innerLineOffset, cornerDecoInnerSizeWithOffset);
      var botLeftStartInner = bounds.bottomLeft +
          Offset(cornerDecoInnerSizeWithOffset, -innerLineOffset);
      var botLeftEndInner = bounds.bottomLeft +
          Offset(innerLineOffset, -cornerDecoInnerSizeWithOffset);
      var botRightStartInner = bounds.bottomRight +
          Offset(-innerLineOffset, -cornerDecoInnerSizeWithOffset);
      var botRightEndInner = bounds.bottomRight +
          Offset(-cornerDecoInnerSizeWithOffset, -innerLineOffset);

      canvas.drawLine(topLeftStartInner, topRightStartInner, innerPaint);
      canvas.drawLine(topRightEndInner, botRightStartInner, innerPaint);
      canvas.drawLine(botRightEndInner, botLeftStartInner, innerPaint);
      canvas.drawLine(botLeftEndInner, topLeftEndInner, innerPaint);

      var thetaInner = innerLineOffset / cornerDecoInnerSize;
      var circleLengthInner = math.pi / 2 - 2 * thetaInner;
      var cornerDecoInnerSizeDoubled = cornerDecoInnerSize * 2;

      canvas.drawArc(
          Rect.fromLTWH(
              bounds.left - cornerDecoInnerSize,
              bounds.top - cornerDecoInnerSize,
              cornerDecoInnerSizeDoubled,
              cornerDecoInnerSizeDoubled),
          thetaInner,
          circleLengthInner,
          false,
          innerPaint);
      canvas.drawArc(
          Rect.fromLTWH(
              bounds.left - cornerDecoInnerSize,
              bounds.bottom - cornerDecoInnerSize,
              cornerDecoInnerSizeDoubled,
              cornerDecoInnerSizeDoubled),
          math.pi * 1.5 + thetaInner,
          circleLengthInner,
          false,
          innerPaint);
      canvas.drawArc(
          Rect.fromLTWH(
              bounds.right - cornerDecoInnerSize,
              bounds.bottom - cornerDecoInnerSize,
              cornerDecoInnerSizeDoubled,
              cornerDecoInnerSizeDoubled),
          math.pi + thetaInner,
          circleLengthInner,
          false,
          innerPaint);
      canvas.drawArc(
          Rect.fromLTWH(
              bounds.right - cornerDecoInnerSize,
              bounds.top - cornerDecoInnerSize,
              cornerDecoInnerSizeDoubled,
              cornerDecoInnerSizeDoubled),
          math.pi / 2 + thetaInner,
          circleLengthInner,
          false,
          innerPaint);
    }

    if(fillCorners){

      var cornerDecoSizeHalf = cornerDecoSize - linesOffset;
      var cornerDecoSizeHalfDoubled = cornerDecoSizeHalf * 2;
      //corners filled
      canvas.drawArc(
          Rect.fromLTWH(
              bounds.left - cornerDecoSizeHalf,
              bounds.top - cornerDecoSizeHalf,
              cornerDecoSizeHalfDoubled,
              cornerDecoSizeHalfDoubled),
          0,
          math.pi / 2,
          true,
          cornerPaint);
      canvas.drawArc(
          Rect.fromLTWH(
              bounds.left - cornerDecoSizeHalf,
              bounds.bottom - cornerDecoSizeHalf,
              cornerDecoSizeHalfDoubled,
              cornerDecoSizeHalfDoubled),
          math.pi * 1.5,
          math.pi / 2,
          true,
          cornerPaint);
      canvas.drawArc(
          Rect.fromLTWH(
              bounds.right - cornerDecoSizeHalf,
              bounds.bottom - cornerDecoSizeHalf,
              cornerDecoSizeHalfDoubled,
              cornerDecoSizeHalfDoubled),
          math.pi,
          math.pi / 2,
          true,
          cornerPaint);
      canvas.drawArc(
          Rect.fromLTWH(
              bounds.right - cornerDecoSizeHalf,
              bounds.top - cornerDecoSizeHalf,
              cornerDecoSizeHalfDoubled,
              cornerDecoSizeHalfDoubled),
          math.pi / 2,
          math.pi / 2,
          true,
          cornerPaint);
    }
  }
}
