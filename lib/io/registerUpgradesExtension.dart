import 'package:flexbackend/io/WorldManager.dart';
import '../components/health.dart';
import '../components/healthUpgrade.dart';

extension RegisterUpgradesExtension on WorldManager {
  void registerUpgrades() {
    registerUpgrade(
        (e) => (e as HealthComponent).maxHitpoints,
        (e) => (e as HealthUpgradeComponent).maxHitpointsUpgrade,
        HealthComponent.propertyName,
        HealthUpgradeComponent.propertyName);
  }
}