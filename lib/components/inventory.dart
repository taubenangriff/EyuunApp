import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/components/EyuunComponent.dart';

part 'inventory.mapper.dart';

@MappableClass()
class InventoryDynamic with InventoryDynamicMappable {

}

class InventoryComponent extends EyuunComponent<int> {

  Map<String, int> items = {};
  List<String> uniqueItemObjectIds = [];

  void addItem(String typeId, int count) {
    if(items.containsKey(typeId)){
      items[typeId] = items[typeId]! + count;
      return;
    }

    items[typeId] = count;
  }

  void giveUniqueItem(String objectId) {
    if(uniqueItemObjectIds.contains(objectId)) {
      return;
    }

    uniqueItemObjectIds.add(objectId);
  }

  @override
  String getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }

  @override
  void init([int? data]) {
    // TODO: implement init
  }
  @override
  void reset() {
    // TODO: implement reset
  }

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
    // TODO: implement saveDynamicData
    throw UnimplementedError();
  }
}