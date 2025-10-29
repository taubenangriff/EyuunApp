import 'dart:collection';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/components/EntityExtensions.dart';
import 'package:flexbackend/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';

part 'inventory.mapper.dart';

@MappableClass()
class InventoryDynamic with InventoryDynamicMappable {
  List<InventoryItemDynamic> items;

  InventoryDynamic(this.items);
}

@MappableClass()
class InventoryItemDynamic with InventoryItemDynamicMappable {
  String? objectId;
  String typeId;
  int count;
  int slot;

  InventoryItemDynamic(this.objectId, this.typeId, this.count, this.slot);
}

class InventoryItem {
  String? objectId;
  String typeId;

  int count;
  InventoryItem(this.typeId, {this.count = 1});

  //Some items are dynamically put together, so we need to handle them specifically to get their nameables and such.
  bool isCustomItem() => objectId != null;

  static InventoryItem fromEntity(Entity entity) {
    var item = InventoryItem(entity.getObjectId());
    item.objectId = entity.getTypeId();
    item.count = 1;
    return item;
  }

  static InventoryItem fromDynamic(InventoryItemDynamic dyn) {
    var item = InventoryItem(dyn.typeId, count: dyn.count);
    item.objectId = dyn.objectId;
    return item;
  }
}

class InventoryComponent extends EyuunComponent<int> {
  static const propertyName = "inventory";
  int maxCapacity = 100;

  Map<int, InventoryItem> items = {};

  void clearSlot(int index) {
    items.remove(index);
  }

  void addItemToFirstFreeSlot(InventoryItem item) {
    var index = getNextFreeSlotIndex();

    if (index != -1) {
      addItemToSlot(item, index);
    }
  }

  void addItemToSlot(InventoryItem item, int index) {
    if (items[index] != null) {
      throw ArgumentError("The slot in question is already taken");
    }

    items[index] = item;
  }

  InventoryItem? getSlotItem(int index) {
    if (!items.containsKey(index)) {
      return null;
    }

    return items[index];
  }

  int getNextFreeSlotIndex() {
    for (int i = 0; i < maxCapacity; i++) {
      if (!items.containsKey(i)) {
        return i;
      }
    }

    return -1;
  }

  void addAll(Iterable<InventoryItem> items) {
    for (var item in items) {
      addItemToFirstFreeSlot(item);
    }
  }

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    // TODO: implement init
  }
  @override
  void reset() {
    items.clear();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = InventoryDynamicMapper.fromMap(dynamicData);
    for(var item in dyn.items) {
      var addItem = InventoryItem.fromDynamic(item);
      items[item.slot] = addItem;
    }
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // TODO: implement loadStaticData
  }

  @override
  Map<String, dynamic> saveDynamicData() => InventoryDynamic(items
          .map((index, item) => MapEntry(
              index,
              InventoryItemDynamic(
                  item.objectId, item.typeId, item.count, index)))
          .values
          .toList())
      .toMap();
}
