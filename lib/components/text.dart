import 'package:dart_mappable/dart_mappable.dart';

import '../core/components/EyuunComponent.dart';

part 'text.mapper.dart';

@MappableClass()
class TextStatic with TextStaticMappable {
  String? textOverride;
  String? fluff;

  TextStatic(this.textOverride, this.fluff);
}

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
  }

  @override
  String getName() => propertyName;

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // TODO: implement loadDynamicData
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = TextStaticMapper.fromMap(staticData);
    textOverride = stat.textOverride;
    fluff = stat.fluff;
  }

  @override
  Map<String, dynamic> saveDynamicData() {
    return <String, dynamic>{};
  }
}