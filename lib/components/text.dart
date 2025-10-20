import 'EyuunComponent.dart';

class TextComponent extends EyuunComponent<String> {
  static String propertyName = "text";

  String? textOverride;
  String? fluff;

  @override
  void init([String? textKey, String? fluff]) {
    this.textOverride = textKey;
    this.fluff = fluff;
  }

  @override
  void reset() {
    textOverride = "";
    fluff = "";
  }

  @override
  String getName() => propertyName;

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // TODO: implement loadDynamicData
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // TODO: implement loadStaticData
  }

  @override
  Map<String, dynamic> saveDynamicData() {
    return <String, dynamic>{};
  }
}