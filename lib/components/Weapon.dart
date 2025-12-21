import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/components/CraftMethod.dart';
import 'package:flexbackend/components/Skillcheck.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../enums/FightingType.dart';

part 'Weapon.mapper.dart';

@MappableClass()
class WeaponDynamic with WeaponDynamicMappable {
  FightingType fightingType;
  String weaponType;
  String material;
  String craftMethod;

  WeaponDynamic(this.fightingType, this.weaponType, this.material, this.craftMethod);
}

class WeaponComponent extends EyuunComponent<int> {
  static const String propertyName = "weapon";

  late FightingType fightingType;

  /// Link to an asset with a [SkillcheckComponent] that describes this weapons Type
  late AssetLink weaponType;

  /// Link to an asset that describes this weapons material.
  late AssetLink material;

  /// AssetLink to the [CraftMethodComponent] that describes this weapons craft method.
  late AssetLink craftMethod;

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
    weaponType = AssetLink(dyn.weaponType);
    material = AssetLink(dyn.material);
    craftMethod = AssetLink(dyn.craftMethod);
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // TODO: implement loadStaticData
  }

  @override
  void reset() {
    weaponType = AssetLink.invalid();
    material = AssetLink.invalid();
    craftMethod = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => WeaponDynamic(fightingType, weaponType.id, material.id, craftMethod.id).toMap();
}