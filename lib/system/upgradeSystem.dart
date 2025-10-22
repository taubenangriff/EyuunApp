import 'package:flexbackend/components/upgradable.dart';
import 'package:oxygen/oxygen.dart';

import '../core/WorldManager.dart';

class UpgradeSystem extends System {
  late Query query;

  @override
  void init() {
    query = createQuery([Has<UpgradableComponent>()]);
  }

  @override
  void execute(double delta) {
    for (var entity in query.entities) {
      resetUpgrades(entity);

      var upgradeAssets = entity.get<UpgradableComponent>()!.getAllUpgrades();
      for(var upgrade in upgradeAssets){
        applyUpgrade(entity, upgrade);
      }
    }
  }

  void resetUpgrades(Entity entity){
    for(var upgradeDescriptor in WorldManager.instance.upgrades) {
      var baseComponent = WorldManager.instance.getComponentFromEntity(upgradeDescriptor.typeIdBase, entity);

      if(baseComponent == null){
        continue;
      }
      var upgradableInt = upgradeDescriptor.getBase(baseComponent);
      upgradableInt.reset();
    }
  }

  void applyUpgrade(Entity entity, Entity buff) {
    for(var upgradeDescriptor in WorldManager.instance.upgrades) {
      var baseComponent = WorldManager.instance.getComponentFromEntity(upgradeDescriptor.typeIdBase, entity);
      var upgradeComponent = WorldManager.instance.getComponentFromEntity(upgradeDescriptor.typeIdUpgrade, buff);

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