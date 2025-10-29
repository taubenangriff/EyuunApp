
import 'package:flexbackend/components/Boon.dart';
import 'package:flexbackend/components/healthUpgrade.dart';
import 'package:flexbackend/components/inventory.dart';
import 'package:flexbackend/components/upgradable.dart';

import '../components/Attributes.dart';
import '../components/Item.dart';
import '../components/health.dart';
import 'components/standard.dart';
import '../components/text.dart';
import 'services/WorldManager.dart';

extension RegisterUpgradesExtension on WorldManager {
  void registerComponents() {
    registerComponent<StandardComponent, String>(StandardComponent.propertyName, () => StandardComponent());
    registerComponent<HealthComponent, int>(HealthComponent.propertyName, () => HealthComponent());
    registerComponent<AttributesComponent, int>(AttributesComponent.propertyName, () => AttributesComponent());
    registerComponent<UpgradableComponent, int>(UpgradableComponent.propertyName, () => UpgradableComponent());
    registerComponent<HealthUpgradeComponent, int>(HealthUpgradeComponent.propertyName, () => HealthUpgradeComponent());
    registerComponent<BoonComponent, int>(BoonComponent.propertyName, () => BoonComponent());
    registerComponent<InventoryComponent, int>(InventoryComponent.propertyName, () => InventoryComponent());
    registerComponent<TextComponent, String>(TextComponent.propertyName, () => TextComponent());
    registerComponent<ItemComponent, int>(ItemComponent.propertyName, () => ItemComponent());
  }
}