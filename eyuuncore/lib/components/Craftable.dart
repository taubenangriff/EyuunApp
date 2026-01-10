import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/UpgradableInt.dart';

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

  CraftableDynamic({this.material, this.craftMethod, this.upgradeSlots = 0});
}

class CraftableComponent extends EyuunComponent<int> {
  static const String propertyName = "craftable";

  late AssetLink? material;
  late AssetLink? craftMethod;
  late UpgradableInt upgradeSlots;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = CraftableDynamicMapper.fromMap(dynamicData);
    material = dyn.material;
    craftMethod = dyn.craftMethod;
    upgradeSlots = dyn.upgradeSlots.upgradable;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // nothing to load here
  }

  @override
  void reset() {
    material = AssetLink.invalid();
    craftMethod = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}