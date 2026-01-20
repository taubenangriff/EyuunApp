import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgressDecoration extends Decoration {
  CircleProgressDecoration(
      {required this.linePaint,
      this.thickness = 12,
      this.backgroundPaint,
      this.segments = 1,
      this.lineWidth = 2});
  final Paint linePaint;
  final Color? backgroundPaint;
  final double thickness;
  final double lineWidth;
  final int segments;

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _CircleProgressDecorationPainter(
        linePaint, thickness, lineWidth, segments);
  }
}

class _CircleProgressDecorationPainter extends BoxPainter {
  _CircleProgressDecorationPainter(
      this.linePaint, this.thickness, this.lineWidth, this.segments);
  final Paint linePaint;
  final double thickness;
  final double lineWidth;
  final int segments;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & (configuration.size ?? const Size(0, 0));
    _drawDecoration(canvas, bounds);
  }

  void _drawDecoration(Canvas canvas, Rect bounds) {
    var diameter = min(bounds.width, bounds.height);
    var radius = diameter / 2;
    var innerRadius = radius - thickness;
    var outerLine = Paint.from(linePaint);
    outerLine.style = PaintingStyle.stroke;
    outerLine.strokeWidth = lineWidth;

    var shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth+1
      ..color = Colors.black.withAlpha(120)
      ..maskFilter =
      MaskFilter.blur(BlurStyle.solid, convertRadiusToSigma(3));

    if (segments > 0) {
      var dx = bounds.center.dx;
      var dy = bounds.center.dy;
      var rotateAngle = (2 * pi) / segments;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(pi);
      for (int i = 0; i < segments; i++) {
        canvas.rotate(rotateAngle);
        canvas.drawLine(Offset(0, innerRadius), Offset(0, radius), shadowPaint);
        canvas.drawLine(Offset(0, innerRadius), Offset(0, radius), outerLine);
      }
      canvas.restore();
    }
    canvas.drawCircle(bounds.center, radius, shadowPaint);
    canvas.drawCircle(bounds.center, radius, outerLine);
    canvas.drawCircle(bounds.center, innerRadius, shadowPaint);
    canvas.drawCircle(bounds.center, innerRadius, outerLine);
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
