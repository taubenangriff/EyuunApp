import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import '../core/components/EyuunComponent.dart';

part 'Item.mapper.dart';

@MappableClass()
@reflector
class ItemStatic with ItemStaticMappable, ComponentReflectable {
  String categoryText;
  ItemStatic(this.categoryText);
}

class ItemComponent extends EyuunComponent<int> {
  static const String propertyName = "item";

  late String categoryText;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    // TODO: implement init
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // TODO: implement loadDynamicData
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = ItemStaticMapper.fromMap(staticData);
    categoryText = stat.categoryText;
  }

  @override
  void reset() {
    categoryText = "";
  }

  @override
  Map<String, dynamic> saveDynamicData() {
    return <String, dynamic>{};
  }

}