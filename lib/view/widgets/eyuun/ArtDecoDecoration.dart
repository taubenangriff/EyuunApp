import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:eyuunapp/view/widgets/eyuun/EyuunUiImageProvider.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:flutter/material.dart';

import 'Brushes.dart';

class ArtDecoDecoration extends Decoration {
  final Paint paint;
  ArtDecoDecoration({required this.paint});

  @override
  BoxPainter createBoxPainter([void Function()? onChanged]) {
    return _ArtDecoDecorationPainter(paint);
  }
}

class _ArtDecoDecorationPainter extends BoxPainter {
  _ArtDecoDecorationPainter(this.paintBrush);

  final Paint paintBrush;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect bounds = offset & (configuration.size ?? const Size(0, 0));

    var cornerimage = locator<EyuunUiImagerProvider>().getImage("data/base/ui/bg/artdecocorner.png");

    if(cornerimage == null){
      return;
    }

    double cornerSize = 46;

    var width = cornerimage.width / 2;
    var height = cornerimage.height / 2;

    var imageTopLeft = Rect.fromLTWH(0, 0, width, height);
    var imageTopRight = Rect.fromLTWH(width, 0, width, height);
    var imageBotLeft = Rect.fromLTWH(0, height, width, height);
    var imageBotRight = Rect.fromLTWH(width, height, width, height);

    var destTopLeft = Rect.fromCenter(center: bounds.topLeft, width: cornerSize, height: cornerSize);
    var destTopRight = Rect.fromCenter(center: bounds.topRight, width: cornerSize, height: cornerSize);
    var destBotLeft = Rect.fromCenter(center: bounds.bottomLeft, width: cornerSize, height: cornerSize);
    var destBotRight = Rect.fromCenter(center: bounds.bottomRight, width: cornerSize, height: cornerSize);

    paintBrush.colorFilter = ColorFilter.mode(Colors.redAccent, BlendMode.srcATop);

    canvas.drawImageRect(cornerimage, imageTopLeft, destTopLeft, paintBrush);
    canvas.drawImageRect(cornerimage, imageTopRight, destTopRight, paintBrush);
    canvas.drawImageRect(cornerimage, imageBotLeft, destBotLeft, paintBrush);
    canvas.drawImageRect(cornerimage, imageBotRight, destBotRight, paintBrush);
  }
}
