import 'package:dart_mappable/dart_mappable.dart';

import '../core/components/EyuunComponent.dart';

part 'text.mapper.dart';

@MappableClass(
  ignoreNull: false
)
class TextStatic with TextStaticMappable {
  String? textOverride;
  String? fluff;
  String? short;

  TextStatic(this.textOverride, this.fluff, this.short);
}

class TextComponent extends EyuunComponent<String> {
  static String propertyName = "text";

  String? textOverride;
  String? fluff;
  String? short;

  @override
  void init([String? data]) {
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
    short = stat.short;
  }

  @override
  Map<String, dynamic> saveDynamicData() {
    return <String, dynamic>{};
  }
}