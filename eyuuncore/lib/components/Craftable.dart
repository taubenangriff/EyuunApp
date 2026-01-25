import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/core/upgrading/UpgradableList.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';

part 'Craftable.mapper.dart';

@MappableClass()
@reflector
class CraftableStatic with CraftableStaticMappable, ComponentReflectable {
  CraftableStatic();
}

@MappableClass()
class CraftableDynamic with CraftableDynamicMappable {
  AssetLink? material;
  AssetLink? craftMethod;
  int upgradeSlots;
  List<AssetLink> upgrades;

  CraftableDynamic({
    this.material,
    this.craftMethod,
    this.upgradeSlots = 0,
    List<AssetLink>? upgrades,
  }) : upgrades = upgrades ?? [];
}

class CraftableComponent extends EyuunComponent<int> {
  static const String propertyName = "craftable";

  late Entity? material;
  late Entity? craftMethod;
  late UpgradableInt upgradeSlots;
  late List<Entity> upgrades;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = CraftableDynamicMapper.fromMap(dynamicData);
    material = dyn.material?.getEntity();
    craftMethod = dyn.craftMethod?.getEntity();
    upgradeSlots = dyn.upgradeSlots.upgradable;
    upgrades = dyn.upgrades.getAssets();
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // nothing to load here
  }

  @override
  void reset() {
    material = null;
    craftMethod = null;
    upgradeSlots = 0.upgradable;
    upgrades = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => CraftableDynamic(
    craftMethod: craftMethod?.asAssetLink(),
    material: material?.asAssetLink(),
    upgrades: upgrades.asAssetLinks(),
    upgradeSlots: upgradeSlots.base,
  ).toMap();
}
