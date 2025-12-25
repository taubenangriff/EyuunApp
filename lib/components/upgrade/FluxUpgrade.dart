import 'package:dart_mappable/dart_mappable.dart';
import '../../core/components/EyuunComponent.dart';

part 'FluxUpgrade.mapper.dart';

@MappableClass()
class FluxUpgradeStatDyn with FluxUpgradeStatDynMappable {
  int fluxCapacityUpgrade;
  int fluxMaximumUpgrade;
  FluxUpgradeStatDyn(
      [this.fluxCapacityUpgrade = 0, this.fluxMaximumUpgrade = 0]);
}

class FluxUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "fluxUpgrade";

  int fluxCapacityUpgrade = 0;
  int fluxMaximumUpgrade = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    fluxCapacityUpgrade = 0;
    fluxMaximumUpgrade = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) =>
      loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = FluxUpgradeStatDynMapper.fromMap(staticData);
    fluxCapacityUpgrade = stat.fluxCapacityUpgrade;
    fluxMaximumUpgrade = stat.fluxMaximumUpgrade;
  }

  @override
  Map<String, dynamic> saveDynamicData() =>
      FluxUpgradeStatDyn(fluxCapacityUpgrade, fluxMaximumUpgrade).toMap();
}
