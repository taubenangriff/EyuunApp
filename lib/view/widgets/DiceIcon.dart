import 'dart:math';

import 'package:eyuunapp/view/decoration/Brushes.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:flutter/material.dart';

class DiceIcon extends StatelessWidget {
  final Dice type;
  final double size;
  final Color color;

  static Map<Dice, String> diceIcons = {
    Dice.d4: "data/base/icons/dice/d4.png",
    Dice.d6: "data/base/icons/dice/d6.png",
    Dice.d8: "data/base/icons/dice/d8.png",
    Dice.d10: "data/base/icons/dice/d10.png",
    Dice.d12: "data/base/icons/dice/d12.png",
    Dice.d20: "data/base/icons/dice/d20.png",
  };

  const DiceIcon({
    super.key,
    required this.type,
    this.size = 40,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (diceIcons.containsKey(type)) {
      return Stack(alignment: Alignment.center,
          fit: StackFit.passthrough,
          children: [
        Image(
            image: AssetImage(diceIcons[type]!),
            width: size + 8,
            height: size + 8),
        Center(child: Text(type.getText(), style: theme.textTheme.headlineMedium?.copyWith(
          shadows: [
            Shadow(
              color: Colors.black,      // Choose the color of the shadow
              blurRadius: 2.0,          // Adjust the blur radius for the shadow effect
              offset: Offset(2.0, 1.0), // Set the horizontal and vertical offset for the shadow
            ),
          ],
          foreground: Brushes.goldSparkling(stepping: 200)..style = PaintingStyle.fill
        ))),
      ]);
    }

    return CustomPaint(
      size: Size(size, size),
      painter: _DicePainter(type, color),
    );
  }
}

class _DicePainter extends CustomPainter {
  final Dice type;
  final Color color;

  _DicePainter(this.type, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final half = size.width / 2;

    switch (type) {
      case Dice.d2:
        // Draw a rectangle (coin-like)
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
        break;
      case Dice.d4:
        // Draw triangle
        final path = Path()
          ..moveTo(center.dx, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case Dice.d6:
        // Draw square
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
        break;
      case Dice.d8:
        // Draw octagon
        final oct = Path();
        final r = half;
        for (int i = 0; i < 8; i++) {
          final angle = (i * 45) * 3.14159265 / 180;
          final x = center.dx + r * 0.7 * cos(angle);
          final y = center.dy + r * 0.7 * sin(angle);
          if (i == 0) {
            oct.moveTo(x, y);
          } else {
            oct.lineTo(x, y);
          }
        }
        oct.close();
        canvas.drawPath(oct, paint);
        break;
      case Dice.d10:
        // Draw pentagon (simplified as 10-sided icon)
        final path = Path();
        final r = half;
        for (int i = 0; i < 10; i++) {
          final angle = (i * 36) * 3.14159265 / 180;
          final x = center.dx + r * 0.7 * cos(angle);
          final y = center.dy + r * 0.7 * sin(angle);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
      case Dice.d12:
        // Draw 12-sided polygon
        final path = Path();
        final r = half;
        for (int i = 0; i < 12; i++) {
          final angle = (i * 30) * 3.14159265 / 180;
          final x = center.dx + r * 0.7 * cos(angle);
          final y = center.dy + r * 0.7 * sin(angle);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
      case Dice.d20:
        // Draw 20-sided polygon
        final path = Path();
        final r = half;
        for (int i = 0; i < 20; i++) {
          final angle = (i * 18) * 3.14159265 / 180;
          final x = center.dx + r * 0.7 * cos(angle);
          final y = center.dy + r * 0.7 * sin(angle);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
        break;
      case Dice.d100:
        // Approximate as a circle
        canvas.drawCircle(center, half, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
