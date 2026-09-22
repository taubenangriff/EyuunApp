import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Item.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/events/EntityDeletedEvent.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

class InventoryController {
  InventoryComponent _inventory;

  InventoryController(this._inventory);

  void acceptItem(InventoryItem item, int slotIndex) {
    if (!isSlotFree(slotIndex)) {
      throw Exception('Slot $slotIndex is already taken.');
    }
    _inventory.items[slotIndex] = item;

    locator<EventBus>().fire(
      EntityUpdatedEvent(locator<CharacterService>().character, _inventory),
    );
  }

  /// returns the slot index currently holding [item], or null if it isn't in this inventory.
  int? getSlotIndexOfItem(InventoryItem item) {
    for (final entry in _inventory.items.entries) {
      if (entry.value == item) {
        return entry.key;
      }
    }
    return null;
  }

  /// checks whether the slot at [slotIndex] is currently free.
  bool isSlotFree(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= _inventory.maxCapacity.current) {
      return false;
    }
    return !_inventory.items.containsKey(slotIndex) ||
        _inventory.items[slotIndex] == null;
  }

  /// adds the entity to the slot at [slotIndex]. The entity must have [ItemComponent].
  ///
  /// Throws an error if the slot is already taken.
  void addObjectToSlot(Entity entity, int slotIndex) {
    if (!isSlotFree(slotIndex)) {
      throw Exception('Slot $slotIndex is already taken.');
    }
    _inventory.items[slotIndex] = InventoryItem.fromEntity(entity);

    locator<EventBus>().fire(
      EntityUpdatedEvent(locator<CharacterService>().character, _inventory),
    );
  }

  /// returns the entity that resides in the slot at [slotIndex], or null if the slotindex is invalid or empty.
  Entity? getItemInSlot(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= _inventory.maxCapacity.current) {
      return null;
    }
    var item = _inventory.items[slotIndex];
    return item?.object;
  }

  /// returns the item count at [slotIndex], or 0 if the slotindex is invalid.
  int getItemCount(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= _inventory.maxCapacity.current) {
      return 0;
    }
    var item = _inventory.items[slotIndex];
    return item?.count ?? 0;
  }

  /// sets the item count of the item at [slotIndex]
  void setItemCountAtSlot(int slotIndex, int newCount) {
    if (slotIndex < 0 || slotIndex >= _inventory.maxCapacity.current) {
      return;
    }
    var item = _inventory.items[slotIndex];
    if (item != null) {
      item.count = newCount;
    }

    locator<EventBus>().fire(
      EntityUpdatedEvent(locator<CharacterService>().character, _inventory),
    );
  }

  /// sets the item count of the item [item]
  void setItemCount(InventoryItem item, int newCount) {
    item.count = newCount;

    locator<EventBus>().fire(
      EntityUpdatedEvent(locator<CharacterService>().character, _inventory),
    );
  }

  /// returns the first free inventory slot
  int getFirstFreeSlotIndex() {
    for (int i = 0; i < _inventory.maxCapacity.current; i++) {
      if (isSlotFree(i)) {
        return i;
      }
    }
    return -1; // no free slot found
  }

  /// returns whether the inventory has reached full capacity.
  bool isFull() => getFirstFreeSlotIndex() == -1;

  /// deletes the item in slot at [slotIndex] from an inventory. Returns the entity that was deleted for easy disposing.
  Entity? deleteItemInSlot(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= _inventory.maxCapacity.current) {
      return null;
    }
    var item = _inventory.items[slotIndex];
    if (item == null) {
      return null;
    }

    locator<EventBus>().fire(
      EntityUpdatedEvent(locator<CharacterService>().character, _inventory),
    );

    return item.object;
  }

  List<Entity> deleteItem(InventoryItem item) {
    return _removeItem(item, kill: true);
  }

  List<Entity> dropItem(InventoryItem item) {
    return _removeItem(item, kill: false);
  }

  /// deletes the item described by [item] from an inventory. Returns the entity that was deleted for easy disposing.
  List<Entity> _removeItem(InventoryItem item, {bool kill = false}) {
    // materialize first: mutating the map while a lazy where() view of its
    // entries is being iterated causes a ConcurrentModificationError.
    var itemsToDelete = _inventory.items.entries
        .where((entry) => entry.value == item)
        .toList();

    for (var entry in itemsToDelete) {
      _inventory.items.remove(entry.key);
      if (kill) {
        locator<GameObjectService>().killEntity(entry.value.object);
      }
    }

    locator<EventBus>().fire(
      EntityUpdatedEvent(locator<CharacterService>().character, _inventory),
    );

    return itemsToDelete
        .map((e) => e.value.object)
        .whereType<Entity>()
        .toList();
  }

  /// Moves the item from slot at [oldIndex] to [newIndex].
  ///
  /// If an item in that slot already exists, it swaps them.
  void moveItem(int oldIndex, int newIndex) {
    if (oldIndex < 0 ||
        oldIndex >= _inventory.maxCapacity.current ||
        newIndex < 0 ||
        newIndex >= _inventory.maxCapacity.current) {
      return;
    }

    var oldItem = _inventory.items[oldIndex];
    var newItem = _inventory.items[newIndex];

    if (oldItem == null && newItem == null) {
      return;
    }

    _inventory.items[oldIndex] = newItem!;
    _inventory.items[newIndex] = oldItem!;

    locator<EventBus>().fire(
      EntityUpdatedEvent(locator<CharacterService>().character, _inventory),
    );
  }
}
