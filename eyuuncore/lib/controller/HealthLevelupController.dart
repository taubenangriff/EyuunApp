import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/components/upgrade/HealthUpgrade.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

enum HealthIncreaseMode {
  /// Take the maximum of one dice.
  maximum,

  /// Throw two dice.
  roll,
}

/// Manages the choice of how health is increased during a levelup.
class HealthLevelupController {
  HealthIncreaseMode mode = HealthIncreaseMode.maximum;

  /// The value picked for [HealthIncreaseMode.roll].
  int rolledValue = 2;
  Entity levelingEntity;
  List<AttributeEntry> healthEntries = [];

  HealthLevelupController(this.levelingEntity) {
    if (!levelingEntity.has<AttributesComponent>()) {
      throw ArgumentError('Leveling entity must have an AttributesComponent.');
    }
    healthEntries = _sortedEntries();
  }

  /// Tie-break order: on equal dice, earlier entries count as smaller.
  static const _healthStatIds = [
    'baseSkill_Courage',
    'baseSkill_Constitution',
    'baseSkill_Strength',
  ];

  /// The health attributes sorted ascending by dice, ties broken by [_healthStatIds].
  List<AttributeEntry> _sortedEntries() {
    final attributes = levelingEntity.get<AttributesComponent>()!;
    final entries = _healthStatIds.map((id) {
      return attributes.getStatEntry(id) ??
          (throw StateError('Leveling entity has no attribute $id'));
    }).toList();
    final order = {for (var i = 0; i < entries.length; i++) entries[i]: i};
    entries.sort((a, b) {
      final byDice = a.dice.index.compareTo(b.dice.index);
      return byDice != 0 ? byDice : order[a]!.compareTo(order[b]!);
    });
    return entries;
  }

  void refresh() {
    healthEntries = _sortedEntries();
  }

  AttributeEntry getMinimalDice() => healthEntries[0];

  AttributeEntry getMiddleDice() => healthEntries[1];

  AttributeEntry getMaximalDice() => healthEntries[2];

  /// The health gained, based on the middle dice.
  int getHealthIncrease() {
    final max = getMiddleDice().dice.getValue();
    return mode == HealthIncreaseMode.maximum
        ? max
        : rolledValue.clamp(2, 2 * max);
  }

  /// Applies the chosen health increase to [levelingEntity] as an upgrade and raises its current hitpoints.
  void applyHealthIncrease() {
    final health = levelingEntity.get<HealthComponent>();
    final upgradable = levelingEntity.get<UpgradableComponent>();
    if (health == null || upgradable == null) {
      throw StateError(
        'Leveling entity needs a HealthComponent and an UpgradableComponent.',
      );
    }

    final upgrade = locator<GameObjectService>().createInstance(
      'levelup_health_upgrade',
    );
    final healthUpgrade = upgrade?.get<HealthUpgradeComponent>();
    if (upgrade == null || healthUpgrade == null) {
      throw StateError('Could not create levelup_health_upgrade.');
    }

    final increase = getHealthIncrease();
    healthUpgrade.maxHitpointsUpgrade = increase;
    upgradable.applyCreatedUpgrade(upgrade);
    health.hitpoints += increase;

    locator<WorldManager>().execute();
    locator<EventBus>().fire(EntityUpdatedEvent(levelingEntity, health));
    locator<EventBus>().fire(EntityUpdatedEvent(levelingEntity, upgradable));
  }
}
