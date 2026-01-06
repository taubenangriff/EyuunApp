import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../../core/components/EyuunComponent.dart';

part 'HealthUpgrade.mapper.dart';

@MappableClass()
@reflector
class HealthUpgradeStatDyn with HealthUpgradeStatDynMappable, ComponentReflectable {
  int maxHitpointsUpgrade;
  int maxShieldUpgrade;
  int maxDeathThrowsUpgrade;
  HealthUpgradeStatDyn(
      [this.maxHitpointsUpgrade = 0,
      this.maxShieldUpgrade = 0,
      this.maxDeathThrowsUpgrade = 0]);
}

class HealthUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "healthUpgrade";

  int maxHitpointsUpgrade = 0;
  int maxShieldUpgrade = 0;
  int maxDeathThrowsUpgrade = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    maxHitpointsUpgrade = 0;
    maxShieldUpgrade = 0;
    maxDeathThrowsUpgrade = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) =>
      loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = HealthUpgradeStatDynMapper.fromMap(staticData);
    maxHitpointsUpgrade = stat.maxHitpointsUpgrade;
    maxShieldUpgrade = stat.maxShieldUpgrade;
    maxDeathThrowsUpgrade = stat.maxDeathThrowsUpgrade;
  }

  @override
  Map<String, dynamic> saveDynamicData() => HealthUpgradeStatDyn(
          maxHitpointsUpgrade, maxShieldUpgrade, maxDeathThrowsUpgrade)
      .toMap();
}
