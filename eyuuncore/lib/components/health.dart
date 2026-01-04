import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/UpgradableInt.dart';

import '../core/components/EyuunComponent.dart';
part 'health.mapper.dart';

@MappableClass()
class HealthDynamic with HealthDynamicMappable {
  int maxHitpoints;
  int hitpoints;
  int shield;
  int deathThrows;

  int naturalArmor;

  HealthDynamic(
      this.maxHitpoints, this.hitpoints, this.shield, this.deathThrows, this.naturalArmor);
}

@MappableClass()
class HealthStatic with HealthStaticMappable {
  int maxShield;
  int maxDeathThrows;

  HealthStatic(this.maxShield, this.maxDeathThrows);
}

class HealthComponent extends EyuunComponent<int> {
  static const String propertyName = "health";

  /// The current hitpoints of the character
  int hitpoints = 0;

  /// The maximum hitpoints of the character
  UpgradableInt maxHitpoints = 0.upgradable;

  /// The current shield points applied
  int shield = 0;

  /// The maximum shield
  UpgradableInt maxShield = 0.upgradable;

  /// the current amount of death throws a character has already thrown.
  int deathThrows = 0;

  /// The maximum amount of death fails this character can roll before dying.
  UpgradableInt maxDeathThrows = 0.upgradable;

  /// the natural armor of a character
  UpgradableInt naturalArmor = 0.upgradable;

  @override
  void init([data]) {
    reset();
  }

  @override
  void reset() {
    hitpoints = 0;
    maxHitpoints = 0.upgradable;
    shield = 0;
    maxShield = 0.upgradable;
    deathThrows = 0;
    maxDeathThrows = 0.upgradable;
    naturalArmor = 0.upgradable;
  }

  bool isInDyingState() => hitpoints <= 0;

  @override
  String getName() => propertyName;

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = HealthDynamicMapper.fromMap(dynamicData);

    hitpoints = dyn.hitpoints;
    shield = dyn.shield;
    deathThrows = dyn.deathThrows;
    maxHitpoints = dyn.maxHitpoints.upgradable;
    naturalArmor = dyn.naturalArmor.upgradable;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = HealthStaticMapper.fromMap(staticData);
    maxShield = stat.maxShield.upgradable;
    maxDeathThrows = stat.maxDeathThrows.upgradable;
    hitpoints = maxHitpoints.current;
  }

  @override
  Map<String, dynamic> saveDynamicData() =>
      HealthDynamic(maxHitpoints.base, hitpoints, shield, deathThrows, naturalArmor.base).toMap();
}
