import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:oxygen/oxygen.dart';

import '../core/registerServices.dart';
import '../core/services/WorldManager.dart';

class CollectActionsSystem extends System {
  WorldManager worldManager = locator<WorldManager>();

  late Query actionUserQuery;
  late Query inventoryQuery;
  late Query combatQuery;
  late Query skillLearnerQuery;

  @override
  void init() {
    actionUserQuery = createQuery([Has<ActionUserComponent>()]);
    inventoryQuery = createQuery([
      Has<ActionUserComponent>(),
      Has<InventoryComponent>(),
    ]);
    combatQuery = createQuery([
      Has<ActionUserComponent>(),
      Has<CombatComponent>(),
    ]);
    combatQuery = createQuery([
      Has<ActionUserComponent>(),
      Has<SkillLearnerComponent>(),
    ]);
  }

  @override
  /// reapplies the effects of all entities with an UpgradableComponent.
  void execute(double delta) {
    for (var entity in actionUserQuery.entities) {
      entity.get<ActionUserComponent>()?.clearRegisteredActions();
    }

    for (var heldWeapon in combatQuery.entities) {
      _addActionsFromWeaponsHeld(heldWeapon);
    }

    for (var skillLearner in skillLearnerQuery.entities){
      _addActionsFromSkillLearner(skillLearner);
    }
  }

  void _addActionsFromSkillLearner(Entity actionUser){
    if (!actionUser.has<SkillLearnerComponent>()) {
      return;
    }
    var skillLearnerComponent = actionUser.get<SkillLearnerComponent>()!;
    var actionUserComponent = actionUser.get<ActionUserComponent>()!;
    for(var trick in skillLearnerComponent.tricks){
      actionUserComponent.addAction(trick);
    }
    for(var spell in skillLearnerComponent.spells){
      actionUserComponent.addAction(spell);
    }
  }

  void _addActionsFromWeaponsHeld(Entity actionUser) {
    if (!actionUser.has<CombatComponent>()) {
      return;
    }
    var combatComponent = actionUser.get<CombatComponent>()!;
    var actionUserComponent = actionUser.get<ActionUserComponent>()!;

    for (var heldItem in combatComponent.equippedItems) {
      if (heldItem.has<WeaponComponent>()) {
        actionUserComponent.addAction(heldItem);
      }

      //add in the actions that the item itself has.
      _copyActionsFromItemToItemHolder(heldItem, actionUserComponent);
    }
  }

  void _copyActionsFromItemToItemHolder(Entity heldItem, ActionUserComponent actionUserComponent) {
    //add in the actions that the item itself has.
    if(heldItem.has<ActionUserComponent>()){
      var actionsFromItem = heldItem.get<ActionUserComponent>()?.getActions() ?? [];
      for(var actionFromItem in actionsFromItem){
        actionUserComponent.addAction(actionFromItem, source: heldItem);
      }
    }
  }

  void _addItemActionsFromInventory(Entity actionUser) {
    if (!actionUser.has<InventoryComponent>()) {
      return;
    }
    var items = actionUser.get<InventoryComponent>()!.getItems();
  }
}
