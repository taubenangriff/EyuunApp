import 'package:eyuuncore/components/inventory.dart';
import 'package:oxygen/oxygen.dart';

class InventoryController {
  InventoryComponent _inventory;

  InventoryController(this._inventory);

  void addObjectToSlot(Entity entity, int slotIndex) => UnimplementedError();

  Entity? getItemInSlot(int slotIndex) {
    UnimplementedError();
    return null;
  }

  int getItemCount(int slotIndex) => 1;

  void setItemCount(int slotIndex, int newCount) => UnimplementedError();

  int getFirstFreeSlotIndex() => 0;

  bool isFull() => false;

  void dropItemInSlot(int slotIndex) => UnimplementedError();

  void dropItem(InventoryItem item) => UnimplementedError();

  void moveItem(int oldIndex, int newIndex) {
    UnimplementedError();
  }
}