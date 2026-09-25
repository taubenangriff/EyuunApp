import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

class CombatController {
  late CombatComponent _combatComponent;
  Entity entity;

  CombatController(this.entity) {
    _combatComponent = entity.get<CombatComponent>()!;
  }

  int getEquipmentSlotCount() => _combatComponent.equipmentSlotCount;

  bool canEquipHoldable(Entity entity) => true;

  Entity? getHoldable(int slotIndex) =>
      _combatComponent.getHoldableEntity(slotIndex);

  void equipHoldable(int slotIndex, Entity entity) {
    _combatComponent.equipHoldable(slotIndex, entity);
    locator<WorldManager>().execute();
    locator<EventBus>().fire(
      EntityUpdatedEvent(
        locator<CharacterService>().character,
        _combatComponent,
      ),
    );
  }

  Entity? unequipHoldable(int heldIndex) {
    final entity = _combatComponent.unequipHoldable(heldIndex);
    locator<WorldManager>().execute();
    locator<EventBus>().fire(
      EntityUpdatedEvent(
        locator<CharacterService>().character,
        _combatComponent,
      ),
    );
    return entity;
  }

  bool canEquipArmor(Entity entity) => true;

  Entity? getArmor() => _combatComponent.armor;

  void equipArmor(Entity entity) {
    _combatComponent.equipArmor(entity);
    locator<WorldManager>().execute();
    locator<EventBus>().fire(
      EntityUpdatedEvent(
        locator<CharacterService>().character,
        _combatComponent,
      ),
    );
  }

  Entity? unequipArmor() {
    final entity = _combatComponent.armor;
    _combatComponent.unequipArmor();
    locator<WorldManager>().execute();
    locator<EventBus>().fire(
      EntityUpdatedEvent(
        locator<CharacterService>().character,
        _combatComponent,
      ),
    );
    return entity;
  }
}
