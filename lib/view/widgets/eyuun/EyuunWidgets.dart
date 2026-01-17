import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Brushes.dart';
import 'EyuunDecoration.dart';

class EyuunWidgets {

  static Widget informationBox({required Widget child, required String link, String tooltip = ""}){
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
      width = 130,
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
}
