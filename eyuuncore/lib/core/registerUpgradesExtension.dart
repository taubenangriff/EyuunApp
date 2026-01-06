import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/CharacterPath.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/upgrade/ArmorUpgrade.dart';
import 'package:eyuuncore/components/upgrade/AttributesUpgrade.dart';
import 'package:eyuuncore/components/upgrade/FluxUpgrade.dart';
import 'package:eyuuncore/components/upgrade/LanguageLearnerUpgrade.dart';
import 'package:eyuuncore/components/upgrade/TalentsUpgrade.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';

import '../components/health.dart';
import '../components/upgrade/CharacterPathUpgrade.dart';
import '../components/upgrade/CombatUpgrade.dart';
import '../components/upgrade/HealthUpgrade.dart';

extension RegisterUpgradesExtension on WorldManager {
  void registerUpgrades() {
    registerUpgrade(
        (e) => (e as HealthComponent).maxHitpoints,
        (e) => (e as HealthUpgradeComponent).maxHitpointsUpgrade,
        HealthComponent.propertyName,
        HealthUpgradeComponent.propertyName);

    // ArmorUpgrade
    registerUpgrade(
        (e) => (e as ArmorComponent).armorToughness,
        (e) => (e as ArmorUpgradeComponent).armorToughnessBonus,
        ArmorComponent.propertyName,
        ArmorUpgradeComponent.propertyName);

    // AttributesUpgrade
    registerUpgrade(
        (e) => (e as AttributesComponent).maxDiceIncreases,
        (e) => (e as AttributesUpgradeComponent).maxDiceIncreasesUpgrade,
        AttributesComponent.propertyName,
        AttributesUpgradeComponent.propertyName);

    // CharacterPathUpgrade
    registerUpgrade(
        (e) => (e as CharacterPathComponent).pathCapacity,
        (e) => (e as CharacterPathUpgradeComponent).pathCapacityUpgrade,
        CharacterPathComponent.propertyName,
        CharacterPathUpgradeComponent.propertyName);

    // CombatUpgrade
    registerUpgrade(
        (e) => (e as CombatComponent).speed,
        (e) => (e as CombatUpgradeComponent).speedUpgrade,
        CombatComponent.propertyName,
        CombatUpgradeComponent.propertyName);
    registerUpgrade(
        (e) => (e as CombatComponent).evasion,
        (e) => (e as CombatUpgradeComponent).evasionUpgrade,
        CombatComponent.propertyName,
        CombatUpgradeComponent.propertyName);
    registerUpgrade(
        (e) => (e as CombatComponent).initiative,
        (e) => (e as CombatUpgradeComponent).initiativeUpgrade,
        CombatComponent.propertyName,
        CombatUpgradeComponent.propertyName);
    registerUpgrade(
        (e) => (e as CombatComponent).actionsPerRound,
        (e) => (e as CombatUpgradeComponent).actionsPerRoundUpgrade,
        CombatComponent.propertyName,
        CombatUpgradeComponent.propertyName);
    registerUpgrade(
        (e) => (e as CombatComponent).reactionsPerRound,
        (e) => (e as CombatUpgradeComponent).reactionsPerRoundUpgrade,
        CombatComponent.propertyName,
        CombatUpgradeComponent.propertyName);

    // FluxUpgrade
    registerUpgrade(
        (e) => (e as FluxComponent).fluxCapacity,
        (e) => (e as FluxUpgradeComponent).fluxCapacityUpgrade,
        FluxComponent.propertyName,
        FluxUpgradeComponent.propertyName);
    registerUpgrade(
        (e) => (e as FluxComponent).fluxMaximum,
        (e) => (e as FluxUpgradeComponent).fluxMaximumUpgrade,
        FluxComponent.propertyName,
        FluxUpgradeComponent.propertyName);

    // HealthUpgrade
    registerUpgrade(
        (e) => (e as HealthComponent).maxHitpoints,
        (e) => (e as HealthUpgradeComponent).maxHitpointsUpgrade,
        HealthComponent.propertyName,
        HealthUpgradeComponent.propertyName);
    registerUpgrade(
        (e) => (e as HealthComponent).maxShield,
        (e) => (e as HealthUpgradeComponent).maxShieldUpgrade,
        HealthComponent.propertyName,
        HealthUpgradeComponent.propertyName);
    registerUpgrade(
        (e) => (e as HealthComponent).maxDeathThrows,
        (e) => (e as HealthUpgradeComponent).maxDeathThrowsUpgrade,
        HealthComponent.propertyName,
        HealthUpgradeComponent.propertyName);

    // LanguageLearnerUpgrade
    registerUpgrade(
        (e) => (e as LanguageLearnerComponent).languageMaxPotential,
        (e) => (e as LanguageLearnerUpgradeComponent).languageMaxPotentialUpgrade,
        LanguageLearnerComponent.propertyName,
        LanguageLearnerUpgradeComponent.propertyName);

    // TalentsUpgrade
    registerUpgrade(
        (e) => (e as SkillLearnerComponent).skillpoints,
        (e) => (e as TalentsUpgradeComponent).addSkillpoints,
        SkillLearnerComponent.propertyName,
        TalentsUpgradeComponent.propertyName);
    registerUpgrade(
        (e) => (e as SkillLearnerComponent).skillCeiling,
        (e) => (e as TalentsUpgradeComponent).skillCeilingUpgrade,
        SkillLearnerComponent.propertyName,
        TalentsUpgradeComponent.propertyName);
  }
}
