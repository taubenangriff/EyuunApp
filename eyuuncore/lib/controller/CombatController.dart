import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:oxygen/oxygen.dart';

class CombatController {
  CombatComponent _combatComponent;

  CombatController(this._combatComponent);

  int getEquipmentSlotCount() => _combatComponent.equipmentSlotCount;

  bool canEquipHoldable(Entity entity) => true;

  Entity? getHoldable(int slotIndex) =>
      _combatComponent.getHoldableEntity(slotIndex);

  void equipHoldable(int slotIndex, Entity entity) {
    _combatComponent.equipHoldable(slotIndex, entity);
    locator<WorldManager>().execute();
  }

  Entity? unequipHoldable(int heldIndex) {
    final entity = _combatComponent.unequipHoldable(heldIndex);
    locator<WorldManager>().execute();
    return entity;
  }

  bool canEquipArmor(Entity entity) => true;

  Entity? getArmor() => _combatComponent.armor;

  void equipArmor(Entity entity) {
    _combatComponent.equipArmor(entity);
    locator<WorldManager>().execute();
  }

  Entity? unequipArmor() {
    final entity = _combatComponent.armor;
    _combatComponent.unequipArmor();
    locator<WorldManager>().execute();
    return entity;
  }
}
