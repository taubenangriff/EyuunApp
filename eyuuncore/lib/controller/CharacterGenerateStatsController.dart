import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attribute.dart';
import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/LanguageLearner.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/enums/AttributeImpactType.dart';
import 'package:eyuuncore/enums/dice.dart';
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

  /// Sums dice value * impact multiplier of [type] over all attributes of the character.
  int _aggregateImpact(AttributeImpactType type) {
    int total = 0;
    for (final entry in attributesComponent.statValues) {
      final impact = entry.stat.get<AttributeComponent>()?.getImpact(type);
      if (impact == null) continue;
      var toAdd = entry.dice.getValue() * impact;
      total += toAdd.round();
    }
    return total;
  }

  int getLanguagePotential() =>
      _aggregateImpact(AttributeImpactType.LanguagePotential);

  int getEvasion() => _aggregateImpact(AttributeImpactType.Evasion);

  int getNaturalArmor() => _aggregateImpact(AttributeImpactType.NaturalArmor);

  int getMaxHealth() =>
      locator<CharacterTablesFeatureComponent>().baseHealth +
      _aggregateImpact(AttributeImpactType.Health);

  int getFlux() => _aggregateImpact(AttributeImpactType.Flux);

  int getInventoryCapacity() =>
      locator<CharacterTablesFeatureComponent>().baseInventoryCapacity +
      _aggregateImpact(AttributeImpactType.Inventory);

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
