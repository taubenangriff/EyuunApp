import 'package:flutter/cupertino.dart';

abstract class AbstractCornerPainter extends CustomPainter {
  Paint primaryLinePaint;
  AbstractCornerPainter(this.primaryLinePaint);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}