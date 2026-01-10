import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Combat.dart';
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
  }

  void _addActionsFromWeaponsHeld(Entity actionUser) {
    if (!actionUser.has<CombatComponent>()) {
      return;
    }
    var combatComponent = actionUser.get<CombatComponent>()!;
    var actionUserComponent = actionUser.get<ActionUserComponent>()!;

    for (var heldItemLink in combatComponent.equippedItems) {
      var heldItem = heldItemLink.getEntity();
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
