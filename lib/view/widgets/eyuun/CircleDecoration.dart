import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

import 'Brushes.dart';

class CircleDecoration extends Decoration {
  const CircleDecoration({required this.linePaint, this.lineWidth = 2, this.addRectangles = false});
  final Paint linePaint;
  final double lineWidth;
  final bool addRectangles;

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _CircleDecorationPainter(linePaint, lineWidth, addRectangles);
  }
}

class _CircleDecorationPainter extends BoxPainter {
  _CircleDecorationPainter(this.linePaint, this.lineWidth, this.addRects);
  final Paint linePaint;
  final double lineWidth;
  final bool addRects;
  
  final int squaresCount = 4;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & (configuration.size ?? const Size(0, 0));
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    var diameter = min(bounds.width, bounds.height);
    var radius = diameter / 2;
    var outerLine = Paint.from(linePaint);
    outerLine.style = PaintingStyle.stroke;
    outerLine.strokeWidth = lineWidth;
    var shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth + 2
      ..color = Colors.black.withAlpha(200)
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, convertRadiusToSigma(3));
    canvas.drawCircle(bounds.center, radius, shadowPaint);
    canvas.drawCircle(bounds.center, radius, outerLine);


    if (addRects && squaresCount > 0) {

      var squarePaintOuter = Paint.from(outerLine)..strokeWidth = 1.5;
      var squarePaintInner = Paint.from(outerLine)..strokeWidth = 1;
      var shadowPaintRect = Paint.from(shadowPaint)..strokeWidth = 2;

      double squareSize = 4;

      var dx = bounds.center.dx;
      var dy = bounds.center.dy;
      var rotateAngle = (2 * pi) / squaresCount;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(pi);
      canvas.rotate(pi / 4);
      for (int i = 0; i < squaresCount; i++) {
        canvas.rotate(rotateAngle);
        var pos = sin(45) * (radius - (squareSize / 1.7));
        var rect = Rect.fromCenter(center: Offset(pos, pos), width: squareSize, height: squareSize);
        canvas.drawRect(rect, shadowPaintRect);
        canvas.drawRect(rect, squarePaintOuter);
      }
      canvas.restore();
    }
    
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
