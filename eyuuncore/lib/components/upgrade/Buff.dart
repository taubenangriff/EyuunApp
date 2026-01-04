import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';

part 'Buff.mapper.dart';

@MappableClass()
class BuffStatic with BuffStaticMappable {
  String textDescription;
  BuffStatic([this.textDescription = ""]);
}

class BuffComponent extends EyuunComponent<int> {
  static const String propertyName = "buff";

  late String textDescription;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = BuffStaticMapper.fromMap(staticData);
    textDescription = stat.textDescription;
  }

  @override
  void reset() {
    textDescription = "";
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}