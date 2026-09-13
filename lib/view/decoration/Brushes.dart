import 'package:flutter/material.dart';

class Brushes {
  static Paint whiteSparkling({double stepping = 100}) {
    Rect bounds = Rect.fromLTWH(0, 0, 30, stepping);
    // Linear gradient for metallic gold effect
    const Gradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: [
        Color(0xFFF7F7F7), // very light highlight (almost white)
        Color(0xFFEFEFEF), // soft light grey
        Color(0xFFE6E6E6), // neutral light grey
        Color(0xFFDCDCDC), // slightly richer grey
        Color(0xFFCFCFCF), // gentle darker accent
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    return Paint()
      ..shader = gradient.createShader(bounds)
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
  }

  static Paint goldSparkling({double stepping = 100}) {
    Rect bounds = Rect.fromLTWH(0, 0, 30, stepping);
    // Linear gradient for metallic gold effect
    const Gradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: [
        Color(0xFFFFF8E1), // very light highlight
        Color(0xFFFFEAA0), // light gold
        Color(0xFFFFD966), // medium gold
        Color(0xFFFFCC33), // slightly richer gold
        Color(0xFFE6C475), // gentle darker accent
      ],
      stops: [0.0, 0.3, 0.7, 0.8, 1.0],
    );

    return Paint()
      ..shader = gradient.createShader(bounds)
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
  }

  static Paint obsidianSparkling({double stepping = 100}) {
    Rect bounds = Rect.fromLTWH(0, 0, 30, stepping);
    // Linear gradient for metallic gold effect
    const Gradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: [
        Color(0xFF2D323A), // dark slate grey highlight
        Color(0xFF3A404A), // charcoal grey
        Color(0xFF474E5A), // graphite mid-grey
        Color(0xFF555D6A), // stone grey mid-tone
        Color(0xFF626B7A), // softened slate grey accent
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    return Paint()
      ..shader = gradient.createShader(bounds)
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
  }

  static Paint silverSparkling({double stepping = 100}) {
    Rect bounds = Rect.fromLTWH(0, 0, 30, stepping);
    // Linear gradient for metallic gold effect
    const Gradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: [
        Color(0xFFF8F9FA), // near-white highlight
        Color(0xFFE6E8EB), // very light silver
        Color(0xFFC9CDD2), // neutral silver
        Color(0xFFB0B5BB), // mid silver
        Color(0xFF9AA0A6), // soft dark accent
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    return Paint()
      ..shader = gradient.createShader(bounds)
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;
  }
}
