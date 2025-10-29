import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/upgradableInt.dart';

import '../core/components/EyuunComponent.dart';
part 'health.mapper.dart';

@MappableClass()
class HealthDynamic with HealthDynamicMappable {
  int hitpoints;
  int shield;
  int deathThrows;

  HealthDynamic(this.hitpoints, this.shield, this.deathThrows);
}

@MappableClass()
class HealthStatic with HealthStaticMappable {
  int maxHitpoints;
  int maxShield;
  int maxDeathThrows;

  HealthStatic(this.maxHitpoints, this.maxShield, this.maxDeathThrows);
}

class HealthComponent extends EyuunComponent<int> {
  static const int DEFAULT_HITPOINTS = 0;
  static const int DEFAULT_MAX_HITPOINTS = 1;
  static const int DEFAULT_SHIELD = 0;
  static const int DEFAULT_MAX_SHIELD = 1;
  static const int DEFAULT_DEATH_THROWS = 0;
  static const int DEFAULT_MAX_DEATH_THROWS = 1;

  static const String propertyName = "health";

  //hitpoints field where upgrades are applied to
  late int hitpoints;
  late UpgradableInt maxHitpoints;

  late int shield;
  late UpgradableInt maxShield;

  late int deathThrows;
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
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = HealthStaticMapper.fromMap(staticData);
    maxHitpoints = stat.maxHitpoints.upgradable;
    maxShield = stat.maxShield.upgradable;
    maxDeathThrows = stat.maxDeathThrows.upgradable;

    hitpoints = maxHitpoints.current;
  }

  @override
  Map<String, dynamic> saveDynamicData() => HealthDynamic(hitpoints, shield, deathThrows).toMap();
}