import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/CraftMethod.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/core/UpgradableInt.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/reflection/reflector.dart';
import '../enums/FightingType.dart';

part 'Weapon.mapper.dart';

@MappableClass()
@reflector
class WeaponStatic with WeaponStaticMappable, ComponentReflectable {
  AssetLink fightingType;
  WeaponStatic(this.fightingType);
}

@MappableClass()
class WeaponDynamic with WeaponDynamicMappable {
  AssetLink fightingType;
  AssetLink? weaponType;
  AssetLink? material;
  AssetLink? craftMethod;
  int upgradeSlots;

  WeaponDynamic(this.fightingType, {this.weaponType, this.material, this.craftMethod, this.upgradeSlots = 0});
}

class WeaponComponent extends EyuunComponent<int> {
  static const String propertyName = "weapon";

  late AssetLink fightingType;

  /// Link to an asset with a [SkillcheckComponent] that describes this weapons Type
  late AssetLink? weaponType;

  /// Link to an asset that describes this weapons material.
  late AssetLink? material;

  /// AssetLink to the [CraftMethodComponent] that describes this weapons craft method.
  late AssetLink? craftMethod;

  UpgradableInt upgradeSlots = 0.upgradable;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = WeaponDynamicMapper.fromMap(dynamicData);
    fightingType = dyn.fightingType;
    weaponType =  dyn.weaponType;
    material = dyn.material;
    craftMethod = dyn.craftMethod;
    upgradeSlots = dyn.upgradeSlots.upgradable;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = WeaponStaticMapper.fromMap(staticData);
    fightingType = stat.fightingType;
  }

  @override
  void reset() {
    weaponType = AssetLink.invalid();
    material = AssetLink.invalid();
    craftMethod = AssetLink.invalid();
    upgradeSlots = 0.upgradable;
  }

  @override
  Map<String, dynamic> saveDynamicData() => WeaponDynamic(fightingType, weaponType: weaponType, material: material, craftMethod: craftMethod, upgradeSlots: upgradeSlots.base).toMap();
}