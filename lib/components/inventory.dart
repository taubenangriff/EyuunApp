import 'package:flexbackend/components/EyuunComponent.dart';

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
  void applyValues(Map<String, dynamic> valueMap) {
    // TODO: implement applyValues
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
  Map<String, dynamic> persist() {
    // TODO: implement persist
    throw UnimplementedError();
  }

  @override
  void reset() {
    // TODO: implement reset
  }

}