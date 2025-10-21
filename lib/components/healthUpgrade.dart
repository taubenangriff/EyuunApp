import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/upgradableInt.dart';

import 'EyuunComponent.dart';

part 'healthUpgrade.mapper.dart';

@MappableClass()
class HealthUpgradeStatic with HealthUpgradeStaticMappable {
  int? maxHitpointsUpgrade;

  HealthUpgradeStatic(this.maxHitpointsUpgrade);
}

class HealthUpgradeComponent extends EyuunComponent<int> {
  late int? maxHitpointsUpgrade = null;

  @override
  static String propertyName = "healthUpgrade";

  String getName() => propertyName;

  @override
  void init([int? data]) {
    // TODO: implement init
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = HealthUpgradeStaticMapper.fromMap(staticData);
    maxHitpointsUpgrade = stat.maxHitpointsUpgrade;
  }

  @override
  void reset() {
    // TODO: implement reset
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) { }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}