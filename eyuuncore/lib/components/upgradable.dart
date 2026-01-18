import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';
import '../core/registerServices.dart';

part 'upgradable.mapper.dart';

@MappableClass()
@reflector
class UpgradableStatic with UpgradableStaticMappable, ComponentReflectable {
  List<AssetLink> defaultUpgrades;

  UpgradableStatic({List<AssetLink>? defaultUpgrades})
    : defaultUpgrades = defaultUpgrades ?? [];
}

@MappableClass()
class UpgradableDynamic with UpgradableDynamicMappable {
  List<AssetLink> appliedUpgrades;

  UpgradableDynamic({List<AssetLink>? appliedUpgrades})
    : appliedUpgrades = appliedUpgrades ?? [];
}

class UpgradableComponent extends EyuunComponent<int> {
  static const String propertyName = "upgradable";

  /// The list of upgrades which are always applied to the entity.
  List<Entity> defaultUpgrades = [];

  /// The list of upgrades which are dynamically applied to the entity.
  List<Entity> appliedUpgrades = [];

  List<Entity> get upgrades => defaultUpgrades + appliedUpgrades;

  void applyUpgrade(Entity entity) =>
      appliedUpgrades.add(entity);

  void removeUpgrades(String upgradeTypeId) =>
      appliedUpgrades.removeWhere((x) => x.getTypeId() == upgradeTypeId);

  List<Entity> getAllUpgrades() {
    return upgrades;
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
  Map<String, dynamic> saveDynamicData() =>
      UpgradableDynamic(appliedUpgrades: appliedUpgrades.asAssetLinks()).toMap();

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = UpgradableDynamicMapper.fromMap(dynamicData);
    appliedUpgrades = dyn.appliedUpgrades.getAssets();
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = UpgradableStaticMapper.fromMap(staticData);
    defaultUpgrades = stat.defaultUpgrades.getAssets();
  }
}
