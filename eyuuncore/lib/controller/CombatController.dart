import 'package:eyuuncore/components/Combat.dart';
import 'package:oxygen/oxygen.dart';

class CombatController {
  CombatComponent _combatComponent;

  CombatController(this._combatComponent);

  int getFreeHands() => 1;

  bool canEquipHoldable(Entity entity) => true;

  void equipHoldable(Entity entity) {
    UnimplementedError();
  }

  bool canEquipArmor(Entity entity) => true;

  void equipArmor(Entity entity) {
    UnimplementedError();
  }

  void unequipArmor() {
    UnimplementedError();
  }
}