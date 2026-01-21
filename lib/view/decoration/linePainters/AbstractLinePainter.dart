import 'package:flutter/cupertino.dart';

abstract class AbstractLinePainter extends CustomPainter {
  Paint primaryLinePaint;
  AbstractLinePainter(this.primaryLinePaint);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}