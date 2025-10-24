
import 'package:flexbackend/components/healthUpgrade.dart';
import 'package:flexbackend/components/upgradable.dart';

import '../components/BasicStats.dart';
import '../components/health.dart';
import '../components/standard.dart';
import 'WorldManager.dart';

extension RegisterUpgradesExtension on WorldManager {
  void registerComponents() {
    registerComponent<StandardComponent, String>(StandardComponent.propertyName, () => StandardComponent());
    registerComponent<HealthComponent, int>(HealthComponent.propertyName, () => HealthComponent());
    registerComponent<BasicStatsComponent, int>(BasicStatsComponent.propertyName, () => BasicStatsComponent());
    registerComponent<UpgradableComponent, int>(UpgradableComponent.propertyName, () => UpgradableComponent());
    registerComponent<HealthUpgradeComponent, int>(HealthUpgradeComponent.propertyName, () => HealthUpgradeComponent());
  }
}