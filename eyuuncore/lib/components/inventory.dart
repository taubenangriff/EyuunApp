import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/objectLink.dart';

part 'inventory.mapper.dart';

@MappableClass()
class InventoryDynamic with InventoryDynamicMappable {
  List<InventoryItemDynamic> items;

  int money;

  InventoryDynamic(this.items, this.money);
}

@MappableClass()
class InventoryItemDynamic with InventoryItemDynamicMappable {
  ObjectLink? objectId;
  AssetLink typeId;
  int count;
  int slot;

  InventoryItemDynamic(this.objectId, this.typeId, this.count, this.slot);
}

class InventoryItem {
  /// If the inventory item links to a specific object, it is linked here
  ObjectLink? object;
  /// The asset key of the asset in inventory. Always stored regardless of specific object (weapon) or just a reusable asset (i.e. drugs etc.)
  AssetLink type;

  /// Amount of this object stored in this inventory Slot.
  int count;
  InventoryItem(this.type, {this.count = 1});

  /// Some items, i.e. weapons, are a specific entity, not just an asset, because they are dynamically put together. This function returns whether a slot stores such a specific object.
  bool isCustomItem() => object != null;

  static InventoryItem fromEntity(Entity entity) {
    var item = InventoryItem(AssetLink.fromEntity(entity));
    item.object = ObjectLink.fromEntity(entity);
    item.count = 1;
    return item;
  }

  static InventoryItem fromDynamic(InventoryItemDynamic dyn) {
    var item = InventoryItem(dyn.typeId, count: dyn.count);
    item.object = dyn.objectId;
    return item;
  }
}

class InventoryComponent extends EyuunComponent<int> {
  static const propertyName = "inventory";

  /// Amount of money a player has
  int money = 0;

  /// Maximum inventory slots
  int maxCapacity = 100;

  /// A map of index to inventory slot. Only indices which actually hold an item are in the map.
  Map<int, InventoryItem> items = {};

  void clearSlot(int index) {
    items.remove(index);
  }

  List<InventoryItem> getItems() => items.values.toList();

  /// Adds an Item to the first free inventory Slot.
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

  /// Gets the item at the inventory position, or null if the slot with given index doesn't store an item.
  InventoryItem? getSlotItem(int index) {
    if (!items.containsKey(index)) {
      return null;
    }

    return items[index];
  }

  /// Gets the next free slot position in inventory.
  int getNextFreeSlotIndex() {
    for (int i = 0; i < maxCapacity; i++) {
      if (!items.containsKey(i)) {
        return i;
      }
    }

    return -1;
  }

  /// Adds all items in the items iterable to inventory.
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
    money = dyn.money;
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
                  item.object, item.type, item.count, index)))
          .values
          .toList(),
          money)
      .toMap();
}
