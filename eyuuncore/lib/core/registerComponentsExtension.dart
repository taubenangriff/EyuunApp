
import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:eyuuncore/components/Boon.dart';
import 'package:eyuuncore/components/CharacterPath.dart';
import 'package:eyuuncore/components/CombatShield.dart';
import 'package:eyuuncore/components/Cost.dart';
import 'package:eyuuncore/components/CraftMethod.dart';
import 'package:eyuuncore/components/DamageType.dart';
import 'package:eyuuncore/components/Equippable.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/Icon.dart';
import 'package:eyuuncore/components/Language.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/components/Project.dart';
import 'package:eyuuncore/components/Projectile.dart';
import 'package:eyuuncore/components/Spell.dart';
import 'package:eyuuncore/components/Talents.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/components/feature/CombatFeature.dart';
import 'package:eyuuncore/components/feature/LevelFeature.dart';
import 'package:eyuuncore/components/feature/PathFeature.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/components/upgrade/ArmorUpgrade.dart';
import 'package:eyuuncore/components/upgrade/AttributesUpgrade.dart';
import 'package:eyuuncore/components/upgrade/Buff.dart';
import 'package:eyuuncore/components/upgrade/CharacterPathUpgrade.dart';
import 'package:eyuuncore/components/upgrade/CombatUpgrade.dart';
import 'package:eyuuncore/components/upgrade/FluxUpgrade.dart';
import 'package:eyuuncore/components/upgrade/HealthUpgrade.dart';
import 'package:eyuuncore/components/upgrade/LanguageLearnerUpgrade.dart';
import 'package:eyuuncore/components/upgrade/TalentsUpgrade.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';
import 'package:oxygen/oxygen.dart';

import '../components/Attributes.dart';
import '../components/Casted.dart';
import '../components/CharacterBase.dart';
import '../components/Combat.dart';
import '../components/Item.dart';
import '../components/LanguageLearner.dart';
import '../components/Path.dart';
import '../components/Skillcheck.dart';
import '../components/health.dart';
import 'components/standard.dart';
import '../components/text.dart';
import 'services/WorldManager.dart';

extension registerComponentsExtension on ComponentRepository {
  void registerComponents() {
    registerComponent<StandardStatic>(StandardComponent.propertyName, (map) => StandardStatic.fromMap(map));
    registerComponent<LanguageStatic>(LanguageComponent.propertyName, (map) => LanguageStaticMapper.fromMap(map));
  }
}

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
    registerComponent<CharacterBaseComponent, int>(CharacterBaseComponent.propertyName, () => CharacterBaseComponent());
    registerComponent<BuffComponent, int>(BuffComponent.propertyName, () => BuffComponent());

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
    registerComponent<LevelFeatureComponent, int>(LevelFeatureComponent.propertyName, () => LevelFeatureComponent());
    registerComponent<CharacterTablesFeatureComponent, int>(CharacterTablesFeatureComponent.propertyName, () => CharacterTablesFeatureComponent());
  }
}