import 'package:EyuunApp/components/inventory.dart';
import 'package:oxygen/oxygen.dart';

class InventoryController {
  InventoryComponent _inventory;

  InventoryController(this._inventory);

  void addItemToSlot(String typeId, int slotIndex, count) => UnimplementedError();

  void addObjectToSlot(Entity entity, int slotIndex) => UnimplementedError();

  Entity? getItemInSlot(int slotIndex) {
    UnimplementedError();
    return null;
  }

  int getItemCount(int slotIndex) => 1;

  void setItemCount(int slotIndex, int newCount) => UnimplementedError();

  bool holdsUniqueItem(int slot) => false;

  int getFirstFreeSlotIndex() => 0;

  bool isFull() => false;

  void clearSlot(int slotIndex) => UnimplementedError();
}