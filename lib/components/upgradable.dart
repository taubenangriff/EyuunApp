import 'package:flexbackend/core/components/EyuunComponent.dart';
import 'package:flexbackend/core/services/assetloader.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:oxygen/oxygen.dart';

import '../core/registerServices.dart';

part 'upgradable.mapper.dart';

@MappableClass()
class UpgradableStatic with UpgradableStaticMappable {
  List<String> defaultUpgrades;

  UpgradableStatic(this.defaultUpgrades);
}

@MappableClass()
class UpgradableDynamic with UpgradableDynamicMappable {
  List<String> appliedUpgrades;

  UpgradableDynamic(this.appliedUpgrades);
}

class UpgradableComponent extends EyuunComponent<int> {
  static const String propertyName = "upgradable";

  List<String> defaultUpgrades = [];
  List<String> appliedUpgrades = [];

  List<String> get upgrades => defaultUpgrades + appliedUpgrades;

  void applyUpgrade(String upgradeTypeId) => appliedUpgrades.add(upgradeTypeId);

  void removeUpgrades(String upgradeTypeId) => appliedUpgrades.removeWhere((x) => x == upgradeTypeId);

  List<Entity> getAllUpgrades() {
    return upgrades
        .map((e) => locator<AssetLoader>().getStatic(e))
        .where((e) => e != null)
        .map((e) => e as Entity)
        .toList();
  }

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    defaultUpgrades.clear();
    appliedUpgrades.clear();
  }

  @override
  Map<String, dynamic> saveDynamicData() => UpgradableDynamic(appliedUpgrades).toMap();

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = UpgradableDynamicMapper.fromMap(dynamicData);
    appliedUpgrades = dyn.appliedUpgrades;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = UpgradableStaticMapper.fromMap(staticData);
    defaultUpgrades = stat.defaultUpgrades;
  }

}