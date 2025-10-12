import 'package:oxygen/oxygen.dart';

import 'EyuunComponent.dart';

class TextComponent extends EyuunComponent<String> {
  static String propertyName = "text";

  String? textKey;
  String? fluff;

  @override
  void init([String? textKey, String? fluff]) {
    this.textKey = textKey;
    this.fluff = fluff;
  }

  @override
  void reset() {
    textKey = "";
    fluff = "";
  }

  @override
  void applyValues(Map<String, dynamic> json) {
    // TODO: implement applyValues
  }

  @override
  Map<String, dynamic> persist() {
    // TODO: implement persist
    throw UnimplementedError();
  }
  @override
  String getName() => propertyName;
}