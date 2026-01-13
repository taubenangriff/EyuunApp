import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';

import '../core/components/EyuunComponent.dart';
import '../core/reflection/reflector.dart';

part 'text.mapper.dart';

@MappableClass(
  ignoreNull: false
)
@reflector
class TextStatic with TextStaticMappable, ComponentReflectable {
  String? textOverride;
  String? fluff;
  String? short;

  TextStatic({this.textOverride, this.fluff, this.short});
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