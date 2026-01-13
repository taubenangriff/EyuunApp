import 'package:flutter/material.dart';

import 'Brushes.dart';
import 'EyuunDecoration.dart';

class EyuunWidgets {
  static Widget floatingActionButton({String text = "", IconData? icon, VoidCallback? onPressed, String tooltip = "", width = 130, height = 90}) {
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
                        if(icon != null)
                          Icon(icon, size: 36, color: color),
                        Text(text, style: TextStyle(color: color))
                      ]))));

  }
}