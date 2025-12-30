
import 'package:EyuunApp/components/Armor.dart';
import 'package:EyuunApp/components/AssetBundle.dart';
import 'package:EyuunApp/components/Boon.dart';
import 'package:EyuunApp/components/CharacterPath.dart';
import 'package:EyuunApp/components/CombatShield.dart';
import 'package:EyuunApp/components/Cost.dart';
import 'package:EyuunApp/components/CraftMethod.dart';
import 'package:EyuunApp/components/DamageType.dart';
import 'package:EyuunApp/components/Equippable.dart';
import 'package:EyuunApp/components/Flux.dart';
import 'package:EyuunApp/components/Icon.dart';
import 'package:EyuunApp/components/Language.dart';
import 'package:EyuunApp/components/PathStep.dart';
import 'package:EyuunApp/components/Project.dart';
import 'package:EyuunApp/components/Projectile.dart';
import 'package:EyuunApp/components/Spell.dart';
import 'package:EyuunApp/components/Talents.dart';
import 'package:EyuunApp/components/Weapon.dart';
import 'package:EyuunApp/components/feature/CombatFeature.dart';
import 'package:EyuunApp/components/feature/PathFeature.dart';
import 'package:EyuunApp/components/inventory.dart';
import 'package:EyuunApp/components/upgradable.dart';
import 'package:EyuunApp/components/upgrade/ArmorUpgrade.dart';
import 'package:EyuunApp/components/upgrade/AttributesUpgrade.dart';
import 'package:EyuunApp/components/upgrade/CharacterPathUpgrade.dart';
import 'package:EyuunApp/components/upgrade/CombatUpgrade.dart';
import 'package:EyuunApp/components/upgrade/FluxUpgrade.dart';
import 'package:EyuunApp/components/upgrade/HealthUpgrade.dart';
import 'package:EyuunApp/components/upgrade/LanguageLearnerUpgrade.dart';
import 'package:EyuunApp/components/upgrade/TalentsUpgrade.dart';

import '../components/Attributes.dart';
import '../components/Casted.dart';
import '../components/Combat.dart';
import '../components/Item.dart';
import '../components/LanguageLearner.dart';
import '../components/Path.dart';
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
    registerComponent<WeaponComponent, int>(WeaponComponent.propertyName, () => WeaponComponent());
    registerComponent<EquippableComponent, int>(EquippableComponent.propertyName, () => EquippableComponent());
    registerComponent<CombatShieldComponent, int>(CombatShieldComponent.propertyName, () => CombatShieldComponent());
    registerComponent<ProjectileComponent, int>(ProjectileComponent.propertyName, () => ProjectileComponent());
    registerComponent<CharacterPathComponent, int>(CharacterPathComponent.propertyName, () => CharacterPathComponent());
    registerComponent<PathStepComponent, int>(PathStepComponent.propertyName, () => PathStepComponent());
    registerComponent<PathComponent, int>(PathComponent.propertyName, () => PathComponent());
    registerComponent<SpellComponent, int>(SpellComponent.propertyName, () => SpellComponent());
    registerComponent<CastedComponent, int>(CastedComponent.propertyName, () => CastedComponent());
    registerComponent<ProjectComponent, int>(ProjectComponent.propertyName, () => ProjectComponent());
    registerComponent<DamageTypeComponent, int>(DamageTypeComponent.propertyName, () => DamageTypeComponent());
    registerComponent<IconComponent, int>(IconComponent.propertyName, () => IconComponent());
    registerComponent<AssetBundleComponent, int>(AssetBundleComponent.propertyName, () => AssetBundleComponent());

    // register Upgrades
    registerComponent<ArmorUpgradeComponent, int>(ArmorUpgradeComponent.propertyName, () => ArmorUpgradeComponent());
    registerComponent<AttributesUpgradeComponent, int>(AttributesUpgradeComponent.propertyName, () => AttributesUpgradeComponent());
    registerComponent<CharacterPathUpgradeComponent, int>(CharacterPathUpgradeComponent.propertyName, () => CharacterPathUpgradeComponent());
    registerComponent<CombatUpgradeComponent, int>(CombatUpgradeComponent.propertyName, () => CombatUpgradeComponent());
    registerComponent<FluxUpgradeComponent, int>(FluxUpgradeComponent.propertyName, () => FluxUpgradeComponent());
    registerComponent<HealthUpgradeComponent, int>(HealthUpgradeComponent.propertyName, () => HealthUpgradeComponent());
    registerComponent<LanguageLearnerUpgradeComponent, int>(LanguageLearnerUpgradeComponent.propertyName, () => LanguageLearnerUpgradeComponent());
    registerComponent<TalentsUpgradeComponent, int>(TalentsUpgradeComponent.propertyName, () => TalentsUpgradeComponent());

    // register Features
    registerComponent<CombatFeatureComponent, int>(CombatFeatureComponent.propertyName, () => CombatFeatureComponent());
    registerComponent<PathFeatureComponent, int>(PathFeatureComponent.propertyName, () => PathFeatureComponent());
  }
}