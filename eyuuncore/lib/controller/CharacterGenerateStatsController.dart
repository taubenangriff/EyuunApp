import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:oxygen/oxygen.dart';

class CharacterGenerateStatsController {
  late AttributesComponent attributesComponent;
  HealthComponent? healthComponent;
  CombatComponent? combatComponent;
  FluxComponent? fluxComponent;
  LanguageLearnerComponent? languageLearnerComponent;
  InventoryComponent? inventoryComponent;

  final Entity _entity;

  CharacterGenerateStatsController(Entity entity) : _entity = entity {
    if (!entity.has<AttributesComponent>()) {
      throw Exception('Entity must have AttributesComponent');
    }
    attributesComponent = entity.get<AttributesComponent>()!;

    healthComponent = _entity.get<HealthComponent>();
    combatComponent = _entity.get<CombatComponent>();
    fluxComponent = _entity.get<FluxComponent>();
    languageLearnerComponent = _entity.get<LanguageLearnerComponent>();
    inventoryComponent = _entity.get<InventoryComponent>();
  }

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
    inventoryComponent?.maxCapacity = getInventoryCapacity().upgradable;

    //give a character 2 equipment slots
    combatComponent?.equipmentSlotCount = 2;

    //give a character 1 action and 1 reaction per round
    combatComponent?.actionsPerRound = 1.upgradable;
    combatComponent?.reactionsPerRound = 1.upgradable;
  }
}
