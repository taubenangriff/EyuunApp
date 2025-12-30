import 'package:flutter/material.dart';

import '../../enums/PathType.dart';

extension PathTypeColor on PathType {
  Color get color {
    switch (this) {
      case PathType.Flux:
        return Colors.blueGrey.shade400;     // calm bluish-grey
      case PathType.Fighter:
        return Colors.red.shade400;           // softer red, not neon
      case PathType.Acolyte:
        return Colors.deepPurple.shade300;    // muted purple
      case PathType.Crafter:
        return Colors.amber.shade400;         // warm but not too bright
    }
  }

  Color get textColor {
    // Optional – choose readable text colors per background
    switch (this) {
      case PathType.Crafter:
        return Colors.black87;
      default:
        return Colors.white;
    }
  }
}