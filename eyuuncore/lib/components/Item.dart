import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../core/components/EyuunComponent.dart';

part 'Item.mapper.dart';

@MappableClass()
@reflector
class ItemStatic with ItemStaticMappable, ComponentReflectable {
  String categoryText;
  int maxStackSize;
  ItemStatic({this.categoryText = "", this.maxStackSize = 0});
}

class ItemComponent extends EyuunComponent<int> {
  static const String propertyName = "item";

  late String categoryText;
  late int maxStackSize;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // TODO: implement loadDynamicData
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = ItemStaticMapper.fromMap(staticData);
    categoryText = stat.categoryText;
    maxStackSize = stat.maxStackSize;
  }

  @override
  void reset() {
    categoryText = "";
    maxStackSize = 0;
  }

  @override
  Map<String, dynamic> saveDynamicData() {
    return <String, dynamic>{};
  }

}