import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';

class CharacterGenerateStatsController {
  AttributesComponent attributesComponent;
  HealthComponent? healthComponent;
  CombatComponent? combatComponent;
  FluxComponent? fluxComponent;
  LanguageLearnerComponent? languageLearnerComponent;
  InventoryComponent? inventoryComponent;
  CharacterGenerateStatsController(
    this.attributesComponent, {
    this.healthComponent,
    this.combatComponent,
    this.fluxComponent,
    this.languageLearnerComponent,
    this.inventoryComponent,
  });

  int getLanguagePotential() =>
      (attributesComponent.getDiceValue('baseSkill_Intelligence') / 2).round();

  int getEvasion() =>
      (attributesComponent.getDiceValue('baseSkill_Agility') / 2).round();

  int getNaturalArmor() =>
      (attributesComponent.getDiceValue('baseSkill_Strength') / 2).round();

  int getMaxHealth() =>
      15 +
      2 *
          (attributesComponent.getDiceValue('baseSkill_Courage') +
              attributesComponent.getDiceValue('baseSkill_Constitution') +
              attributesComponent.getDiceValue('baseSkill_Strength'));

  int getFlux() =>
      (0.5 *
              (attributesComponent.getDiceValue('baseSkill_Intelligence') +
                  attributesComponent.getDiceValue('baseSkill_Intuition') +
                  attributesComponent.getDiceValue('baseSkill_Charisma')))
          .round();

  int getInventoryCapacity() =>
      2 + (attributesComponent.getDiceValue('baseSkill_Strength') / 2).round();

  void finalizeStats() {
    healthComponent?.maxHitpoints = getMaxHealth().upgradable;
    healthComponent?.naturalArmor = getNaturalArmor().upgradable;
    combatComponent?.evasion = getEvasion().upgradable;
    languageLearnerComponent?.languageMaxPotential =
        getLanguagePotential().upgradable;
    fluxComponent?.fluxMaximum = getFlux().upgradable;
    inventoryComponent?.maxCapacity = getInventoryCapacity();
  }
}
