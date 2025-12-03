import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/upgradableInt.dart';

import '../core/components/EyuunComponent.dart';
part 'health.mapper.dart';

@MappableClass()
class HealthDynamic with HealthDynamicMappable {
  int maxHitpoints;
  int hitpoints;
  int shield;
  int deathThrows;

  HealthDynamic(this.maxHitpoints, this.hitpoints, this.shield, this.deathThrows);
}

@MappableClass()
class HealthStatic with HealthStaticMappable {
  int maxShield;
  int maxDeathThrows;

  HealthStatic(this.maxShield, this.maxDeathThrows);
}

class HealthComponent extends EyuunComponent<int> {
  static const int DEFAULT_HITPOINTS = 0;
  static const int DEFAULT_MAX_HITPOINTS = 1;
  static const int DEFAULT_SHIELD = 0;
  static const int DEFAULT_MAX_SHIELD = 1;
  static const int DEFAULT_DEATH_THROWS = 0;
  static const int DEFAULT_MAX_DEATH_THROWS = 1;

  static const String propertyName = "health";

  /// The current hitpoints of the character
  late int hitpoints;

  /// The maximum hitpoints of the character
  late UpgradableInt maxHitpoints;

  /// The current shield points applied
  late int shield;
  /// The maximum shield
  late UpgradableInt maxShield;

  /// the current amount of death throws a character has already thrown.
  late int deathThrows;

  /// The maximum amount of death fails this character can roll before dying.
  late UpgradableInt maxDeathThrows;

  @override
  void init([data]) {
    reset();
  }

  @override
  void reset() {
    hitpoints = DEFAULT_MAX_HITPOINTS;
    maxHitpoints = DEFAULT_MAX_HITPOINTS.upgradable;
    shield = DEFAULT_SHIELD;
    maxShield = DEFAULT_MAX_SHIELD.upgradable;
    deathThrows = DEFAULT_DEATH_THROWS;
    maxDeathThrows = DEFAULT_MAX_DEATH_THROWS.upgradable;
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
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = HealthStaticMapper.fromMap(staticData);
    maxShield = stat.maxShield.upgradable;
    maxDeathThrows = stat.maxDeathThrows.upgradable;

    hitpoints = maxHitpoints.current;
  }

  @override
  Map<String, dynamic> saveDynamicData() => HealthDynamic(maxHitpoints.base, hitpoints, shield, deathThrows).toMap();
}