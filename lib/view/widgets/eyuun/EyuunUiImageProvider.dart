import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class EyuunUiImagerProvider {
  Map<String, ui.Image> _images = {};

  Future<ui.Image> preloadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Image image = await decodeImageFromList(bytes);
    _images[path] = image;
    return image;
  }

  ui.Image? getImage(String path) => _images[path];
}