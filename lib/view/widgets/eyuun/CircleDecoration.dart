import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

import 'Brushes.dart';

class CircleDecoration extends Decoration {
  const CircleDecoration({required this.linePaint, this.lineWidth = 2});
  final Paint linePaint;
  final double lineWidth;

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _CircleDecorationPainter(linePaint, lineWidth);
  }
}

class _CircleDecorationPainter extends BoxPainter {
  _CircleDecorationPainter(this.linePaint, this.lineWidth);
  final Paint linePaint;
  final double lineWidth;

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
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
