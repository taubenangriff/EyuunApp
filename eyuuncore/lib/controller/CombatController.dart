import 'package:eyuuncore/components/Combat.dart';
import 'package:oxygen/oxygen.dart';

class CombatController {
  CombatComponent _combatComponent;

  CombatController(this._combatComponent);

  int getEquipmentSlotCount() => _combatComponent.equipmentSlotCount;

  bool canEquipHoldable(Entity entity) => true;

  Entity? getHoldable(int slotIndex) =>
      _combatComponent.getHoldableEntity(slotIndex);

  void equipHoldable(int slotIndex, Entity entity) =>
      _combatComponent.equipHoldable(slotIndex, entity);

  Entity? unequipHoldable(int heldIndex) =>
      _combatComponent.unequipHoldable(heldIndex);

  bool canEquipArmor(Entity entity) => true;

  Entity? getArmor() => _combatComponent.armor;

  void equipArmor(Entity entity) => _combatComponent.equipArmor(entity);

  Entity? unequipArmor() {
    final entity = _combatComponent.armor;
    _combatComponent.unequipArmor();
    return entity;
  }
}
