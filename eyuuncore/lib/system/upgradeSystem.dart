import 'package:eyuuncore/components/upgradable.dart';
import 'package:oxygen/oxygen.dart';

import '../core/registerServices.dart';
import '../core/services/WorldManager.dart';

class UpgradeSystem extends System {

  WorldManager worldManager = locator<WorldManager>();

  late Query query;

  @override
  void init() {
    query = createQuery([Has<UpgradableComponent>()]);
  }

  @override
  /// reapplies the effects of all entities with an UpgradableComponent.
  void execute(double delta) {
    for (var entity in query.entities) {
      resetUpgrades(entity);

      var upgradeAssets = entity.get<UpgradableComponent>()!.getAllUpgrades();
      for(var upgrade in upgradeAssets){
        applyUpgrade(entity, upgrade);
      }
    }
  }

  /// removes all Upgrades from an entity
  void resetUpgrades(Entity entity){
    _resetUpgradableInts(entity);
    _resetUpgradableLists(entity);
  }

  void _resetUpgradableLists(Entity entity) {
    for(var upgradeDescriptor in worldManager.listUpdates){
      var baseComponent = worldManager.getComponentFromEntity(upgradeDescriptor.typeIdBase, entity);
      if(baseComponent == null){
        continue;
      }
      var upgradableList = upgradeDescriptor.getBase(baseComponent);
      upgradableList.reset();
    }
  }

  void _resetUpgradableInts(Entity entity) {
    for(var upgradeDescriptor in worldManager.upgrades) {
      var baseComponent = worldManager.getComponentFromEntity(upgradeDescriptor.typeIdBase, entity);

      if(baseComponent == null){
        continue;
      }
      var upgradableInt = upgradeDescriptor.getBase(baseComponent);
      upgradableInt.reset();
    }
  }

  /// Applies an upgrade to an entity.
  void applyUpgrade(Entity entity, Entity buff) {
    applyUpgradableInts(entity, buff);
    applyUpgradableLists(entity, buff);
  }

  void applyUpgradableLists(Entity entity, Entity buff){
    for(var upgradeDescriptor in worldManager.listUpdates) {
      var baseComponent = worldManager.getComponentFromEntity(upgradeDescriptor.typeIdBase, entity);
      var upgradeComponent = worldManager.getComponentFromEntity(upgradeDescriptor.typeIdUpgrade, buff);

      if(upgradeComponent == null || baseComponent == null){
        continue;
      }

      var upgradableList = upgradeDescriptor.getBase(baseComponent);
      var upgradeList = upgradeDescriptor.getUpgrade(upgradeComponent);

      if(upgradeList == null) {
        continue;
      }

      for(var entry in upgradeList){
        upgradableList.addUpgrade(entry);
      }
    }
  }

  void applyUpgradableInts(Entity entity, Entity buff) {
    for(var upgradeDescriptor in worldManager.upgrades) {
      var baseComponent = worldManager.getComponentFromEntity(upgradeDescriptor.typeIdBase, entity);
      var upgradeComponent = worldManager.getComponentFromEntity(upgradeDescriptor.typeIdUpgrade, buff);

      if(upgradeComponent == null || baseComponent == null){
        continue;
      }

      var upgradableInt = upgradeDescriptor.getBase(baseComponent);
      var upgrade = upgradeDescriptor.getUpgrade(upgradeComponent);

      if(upgrade == null) {
        continue;
      }

      upgradableInt.upgrade += upgrade;
    }
  }
}