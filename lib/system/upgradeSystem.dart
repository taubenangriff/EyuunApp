import 'package:flexbackend/components/upgradable.dart';
import 'package:oxygen/oxygen.dart';

import '../core/WorldManager.dart';
import '../core/registerServices.dart';

class UpgradeSystem extends System {

  WorldManager worldManager = locator<WorldManager>();

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
    for(var upgradeDescriptor in worldManager.upgrades) {
      var baseComponent = worldManager.getComponentFromEntity(upgradeDescriptor.typeIdBase, entity);

      if(baseComponent == null){
        continue;
      }
      var upgradableInt = upgradeDescriptor.getBase(baseComponent);
      upgradableInt.reset();
    }
  }

  void applyUpgrade(Entity entity, Entity buff) {
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