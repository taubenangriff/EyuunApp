import 'package:eyuuncore/components/inventory.dart';
import 'package:oxygen/oxygen.dart';

class InventoryController {
  InventoryComponent _inventory;

  InventoryController(this._inventory);

  /// checks whether the slot at [slotIndex] is currently free.
  bool isSlotFree(int slotIndex) => true;

  /// adds the entity to the slot at [slotIndex].
  ///
  /// Throws an error if the slot is already taken.
  void addObjectToSlot(Entity entity, int slotIndex) => UnimplementedError();

  /// returns the entity that resides in the slot at [slotIndex], or null if the slotindex is invalid or empty.
  Entity? getItemInSlot(int slotIndex) {
    UnimplementedError();
    return null;
  }

  /// returns the item count at [slotIndex], or 0 if the slotindex is invalid.
  int getItemCount(int slotIndex) => 1;

  /// sets the item count of the item at [slotIndex]
  void setItemCountAtSlot(int slotIndex, int newCount) => UnimplementedError();

  /// sets the item count of the item [item]
  void setItemCount(InventoryItem item, int newCount) => UnimplementedError();

  /// returns the first free inventory slot
  int getFirstFreeSlotIndex() => 0;

  /// returns whether the inventory has reached full capacity.
  bool isFull() => false;

  /// deletes the item in slot at [slotIndex] from an inventory. Returns the entity that was deleted for easy disposing.
  Entity? deleteItemInSlot(int slotIndex) {
    UnimplementedError();
    return null;
  }

  /// deletes the item described by [item] from an inventory. Returns the entity that was deleted for easy disposing.
  Entity? deleteItem(InventoryItem item) {
    UnimplementedError();
    return null;
  }

  /// Moves the item from slot at [oldIndex] to [newIndex].
  ///
  /// If an item in that slot already exists, it swaps them.
  void moveItem(int oldIndex, int newIndex) {
    UnimplementedError();
  }
}