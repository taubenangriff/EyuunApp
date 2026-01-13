import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../core/components/EyuunComponent.dart';
import '../core/reflection/Reflecting.dart';

part 'health.mapper.dart';

@MappableClass()
class HealthDynamic with HealthDynamicMappable {
  int maxHitpoints;
  int hitpoints;
  int temporaryHitpoints;
  int deathThrows;

  int naturalArmor;

  HealthDynamic({
    this.maxHitpoints = 0,
    this.hitpoints = 0,
    this.temporaryHitpoints = 0,
    this.deathThrows = 0,
    this.naturalArmor = 0,
  });
}

@MappableClass()
@reflector
class HealthStatic with HealthStaticMappable, ComponentReflectable {
  int maxDeathThrows;

  HealthStatic({this.maxDeathThrows = 0});
}

class HealthComponent extends EyuunComponent<int> {
  static const String propertyName = "health";

  /// The current hitpoints of the character
  int hitpoints = 0;

  /// The maximum hitpoints of the character
  UpgradableInt maxHitpoints = 0.upgradable;

  /// The current shield points applied
  int temporaryHitpoints = 0;

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
    temporaryHitpoints = 0;
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
    temporaryHitpoints = dyn.temporaryHitpoints;
    deathThrows = dyn.deathThrows;
    maxHitpoints = dyn.maxHitpoints.upgradable;
    naturalArmor = dyn.naturalArmor.upgradable;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = HealthStaticMapper.fromMap(staticData);
    maxDeathThrows = stat.maxDeathThrows.upgradable;
    hitpoints = maxHitpoints.current;
  }

  @override
  Map<String, dynamic> saveDynamicData() => HealthDynamic(
    maxHitpoints: maxHitpoints.base,
    hitpoints: hitpoints,
    temporaryHitpoints: temporaryHitpoints,
    deathThrows: deathThrows,
    naturalArmor: naturalArmor.base,
  ).toMap();
}
