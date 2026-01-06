
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
import 'package:eyuuncore/components/Holdable.dart';
import 'package:eyuuncore/components/Icon.dart';
import 'package:eyuuncore/components/Language.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/components/Project.dart';
import 'package:eyuuncore/components/Projectile.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Spell.dart';
import 'package:eyuuncore/components/Talent.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/components/feature/CombatFeature.dart';
import 'package:eyuuncore/components/feature/ItemShopFeature.dart';
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
import 'package:eyuuncore/core/reflection/EmptyData.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';

import '../components/Attributes.dart';
import '../components/Casted.dart';
import '../components/CharacterBase.dart';
import '../components/Combat.dart';
import '../components/Item.dart';
import '../components/LanguageLearner.dart';
import '../components/Path.dart';
import '../components/Skillcheck.dart';
import '../components/health.dart';
import '../components/text.dart';
import 'components/standard.dart';
import 'services/WorldManager.dart';

extension registerEditorComponentsExtension on ComponentRepository {
  void registerComponents() {
    registerComponent<StandardStatic>(StandardComponent.propertyName, (map) => StandardStatic.fromMap(map), (comp) => comp.toMap());
    registerComponent<HealthStatic>(HealthComponent.propertyName, (map) => HealthStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<AttributesStatic>(AttributesComponent.propertyName, (map) => AttributesStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<UpgradableStatic>(UpgradableComponent.propertyName, (map) => UpgradableStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<BoonStatic>(BoonComponent.propertyName, (map) => BoonStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<EmptyData>(InventoryComponent.propertyName, (map) => EmptyDataMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<TextStatic>(TextComponent.propertyName, (map) => TextStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<ItemStatic>(ItemComponent.propertyName, (map) => ItemStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<SkillcheckStatic>(SkillcheckComponent.propertyName, (map) => SkillcheckStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<EmptyData>(FluxComponent.propertyName, (map) => EmptyDataMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<SkillLearnerStatic>(SkillLearnerComponent.propertyName, (map) => SkillLearnerStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<EmptyData>(CombatComponent.propertyName, (map) => EmptyDataMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CostStatic>(CostComponent.propertyName, (map) => CostStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<LanguageStatic>(LanguageComponent.propertyName, (map) => LanguageStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<EmptyData>(LanguageLearnerComponent.propertyName, (map) => EmptyDataMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CraftMethodStatic>(CraftMethodComponent.propertyName, (map) => CraftMethodStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<ArmorStatic>(ArmorComponent.propertyName, (map) => ArmorStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<EmptyData>(WeaponComponent.propertyName, (map) => EmptyDataMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<EquippableStatDyn>(EquippableComponent.propertyName, (map) => EquippableStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CombatShieldStatDyn>(CombatShieldComponent.propertyName, (map) => CombatShieldStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<ProjectileStatic>(ProjectileComponent.propertyName, (map) => ProjectileStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CharacterPathStatic>(CharacterPathComponent.propertyName, (map) => CharacterPathStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<PathStepStatic>(PathStepComponent.propertyName, (map) => PathStepStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<PathStatic>(PathComponent.propertyName, (map) => PathStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<SpellStatic>(SpellComponent.propertyName, (map) => SpellStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CastedStatic>(CastedComponent.propertyName, (map) => CastedStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<ProjectStatic>(ProjectComponent.propertyName, (map) => ProjectStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<DamageTypeStatic>(DamageTypeComponent.propertyName, (map) => DamageTypeStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<IconStatic>(IconComponent.propertyName, (map) => IconStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<AssetBundleStatic>(AssetBundleComponent.propertyName, (map) => AssetBundleStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CharacterBaseStatic>(CharacterBaseComponent.propertyName, (map) => CharacterBaseStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<BuffStatic>(BuffComponent.propertyName, (map) => BuffStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<TalentStatic>(TalentComponent.propertyName, (map) => TalentStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<HoldableStatic>(HoldableComponent.propertyName, (map) => HoldableStaticMapper.fromMap(map), (comp) => comp.toMap());
    //Upgrades

    registerComponent<ArmorUpgradeStatDyn>(ArmorUpgradeComponent.propertyName, (map) => ArmorUpgradeStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<AttributesUpgradeStatDyn>(AttributesUpgradeComponent.propertyName, (map) => AttributesUpgradeStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CharacterPathUpgradeStatDyn>(CharacterPathUpgradeComponent.propertyName, (map) => CharacterPathUpgradeStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CombatUpgradeStatDyn>(CombatUpgradeComponent.propertyName, (map) => CombatUpgradeStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<FluxUpgradeStatDyn>(FluxUpgradeComponent.propertyName, (map) => FluxUpgradeStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<HealthUpgradeStatDyn>(HealthUpgradeComponent.propertyName, (map) => HealthUpgradeStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<LanguageLearnerUpgradeStatDyn>(LanguageLearnerUpgradeComponent.propertyName, (map) => LanguageLearnerUpgradeStatDynMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<TalentsUpgradeStatDyn>(TalentsUpgradeComponent.propertyName, (map) => TalentsUpgradeStatDynMapper.fromMap(map), (comp) => comp.toMap());

    // register Features
    registerComponent<CombatFeatureStatic>(CombatFeatureComponent.propertyName, (map) => CombatFeatureStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<PathFeatureStatic>(PathFeatureComponent.propertyName, (map) => PathFeatureStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<LevelFeatureStatic>(LevelFeatureComponent.propertyName, (map) => LevelFeatureStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<CharacterTablesFeatureStatic>(CharacterTablesFeatureComponent.propertyName, (map) => CharacterTablesFeatureStaticMapper.fromMap(map), (comp) => comp.toMap());
    registerComponent<ItemShopFeatureStatic>(ItemShopFeatureComponent.propertyName, (map) => ItemShopFeatureStaticMapper.fromMap(map), (comp) => comp.toMap());
  }
}

extension RegisterComponentsExtension on WorldManager {
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
    registerComponent<SkillLearnerComponent, int>(SkillLearnerComponent.propertyName, () => SkillLearnerComponent());
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
    registerComponent<TalentComponent, int>(TalentComponent.propertyName, () => TalentComponent());
    registerComponent<HoldableComponent, int>(HoldableComponent.propertyName, () => HoldableComponent());

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
    registerComponent<ItemShopFeatureComponent, int>(ItemShopFeatureComponent.propertyName, () => ItemShopFeatureComponent());
  }
}