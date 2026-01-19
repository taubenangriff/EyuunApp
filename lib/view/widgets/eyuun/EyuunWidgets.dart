import 'package:eyuunapp/view/widgets/eyuun/CircleProgressDecoration.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Brushes.dart';
import 'CircleDecoration.dart';
import 'EyuunDecoration.dart';

class EyuunWidgets {
  static Widget informationBox(
      {required Widget child, required String link, String tooltip = ""}) {
    return Stack(children: [
      child,
      // The info button in the top right corner
      Positioned(
        top: 12,
        right: 12,
        child: IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: tooltip,
          onPressed: () async {
            if (await canLaunchUrl(Uri.parse(link))) {
              await launchUrl(Uri.parse(link));
            }
          },
        ),
      ),
    ]);
  }

  static Widget spacerVertical() => const SizedBox(height: 16);
  static Widget spacerHorizontal() => const SizedBox(width: 16);

  static Widget eyuunBox({required Widget child, required ThemeData theme}) {
    return DecoratedBox(
        decoration: EyuunDecoration(
            paint: Brushes.goldSparkling(),
            cornerSize: 20,
            background: theme.canvasColor.withAlpha(230)),
        child: Padding(padding: EdgeInsets.all(20), child: child));
  }

  static Widget floatingActionButton(
      {String text = "",
      IconData? icon,
      VoidCallback? onPressed,
      String tooltip = "",
      width = 90,
      height = 90}) {
    var color = Color(0xccfdcc3a);
    return SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
            decoration:
                EyuunDecoration(cornerSize: 12, paint: Brushes.goldSparkling()),
            position: DecorationPosition.foreground,
            child: FloatingActionButton(
                tooltip: tooltip,
                onPressed: onPressed,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) Icon(icon, size: 36, color: color),
                      Text(text, style: TextStyle(color: color))
                    ]))));
  }

  static Widget circularFloatingActionButton(
      {String text = "",
      IconData? icon,
      VoidCallback? onPressed,
      String tooltip = "",
      Color? backgroundColor,
      radius = 100}) {
    var color = const Color(0xccfdcc3a);
    return SizedBox(
        width: radius,
        height: radius,
        child: DecoratedBox(
            decoration: CircleDecoration(
                linePaint: Brushes.goldSparkling(stepping: 20), lineWidth: 3),
            position: DecorationPosition.foreground,
            child: FloatingActionButton(
                backgroundColor: backgroundColor,
                shape: const CircleBorder(),
                tooltip: tooltip,
                onPressed: onPressed,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) Icon(icon, size: 32, color: color),
                      Text(text, style: TextStyle(color: color, fontSize: 20))
                    ]))));
  }

  static Widget circularProgressButton(
      {String text = "",
      IconData? icon,
      VoidCallback? onPressed,
      String tooltip = "",
      double radius = 100,
      int segments = 8,
      double thickness = 12,
      double progress = 0.3,
      Color? progressColor}) {
    var color = const Color(0xccfdcc3a);
    return SizedBox(
        width: radius,
        height: radius,
        child: DecoratedBox(
            decoration: CircleProgressDecoration(
                linePaint: Brushes.goldSparkling(stepping: 20),
                lineWidth: 2.5,
                segments: segments,
                thickness: thickness),
            position: DecorationPosition.foreground,
            child: Stack(fit: StackFit.expand, children: [
              FloatingActionButton(
                  shape: const CircleBorder(),
                  tooltip: tooltip,
                  onPressed: onPressed,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) Icon(icon, size: 28, color: color),
                        Text(text, style: TextStyle(color: color, fontSize: 16))
                      ])),
              IgnorePointer(
                  child: Padding(
                      padding: EdgeInsetsGeometry.all(thickness / 2),
                      child: CircularProgressIndicator(
                        color: progressColor,
                          strokeWidth: thickness, value: progress))),
            ])));
  }
}
