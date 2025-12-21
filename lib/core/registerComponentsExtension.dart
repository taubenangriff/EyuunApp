
import 'package:flexbackend/components/Armor.dart';
import 'package:flexbackend/components/Boon.dart';
import 'package:flexbackend/components/Cost.dart';
import 'package:flexbackend/components/CraftMethod.dart';
import 'package:flexbackend/components/Flux.dart';
import 'package:flexbackend/components/Language.dart';
import 'package:flexbackend/components/Talents.dart';
import 'package:flexbackend/components/healthUpgrade.dart';
import 'package:flexbackend/components/inventory.dart';
import 'package:flexbackend/components/upgradable.dart';

import '../components/Attributes.dart';
import '../components/Combat.dart';
import '../components/Item.dart';
import '../components/LanguageLearner.dart';
import '../components/Skillcheck.dart';
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
    registerComponent<SkillcheckComponent, int>(SkillcheckComponent.propertyName, () => SkillcheckComponent());
    registerComponent<FluxComponent, int>(FluxComponent.propertyName, () => FluxComponent());
    registerComponent<TalentsComponent, int>(TalentsComponent.propertyName, () => TalentsComponent());
    registerComponent<CombatComponent, int>(CombatComponent.propertyName, () => CombatComponent());
    registerComponent<CostComponent, int>(CostComponent.propertyName, () => CostComponent());
    registerComponent<LanguageComponent, int>(LanguageComponent.propertyName, () => LanguageComponent());
    registerComponent<LanguageLearnerComponent, int>(LanguageLearnerComponent.propertyName, () => LanguageLearnerComponent());
    registerComponent<CraftMethodComponent, int>(CraftMethodComponent.propertyName, () => CraftMethodComponent());
    registerComponent<ArmorComponent, int>(ArmorComponent.propertyName, () => ArmorComponent());
  }
}