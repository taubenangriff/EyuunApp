import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/CraftMethod.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Skillcheck.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/reflection/reflector.dart';
import '../enums/FightingType.dart';

part 'Weapon.mapper.dart';

@MappableClass()
@reflector
class WeaponStatic with WeaponStaticMappable, ComponentReflectable {
  AssetLink fightingType;
  double skillMultiplier;
  WeaponStatic({AssetLink? fightingType, this.skillMultiplier = 1})
    : fightingType = fightingType ?? AssetLink.invalid();
}

@MappableClass()
class WeaponDynamic with WeaponDynamicMappable {
  AssetLink fightingType;
  AssetLink? weaponType;
  double skillMultiplier;

  WeaponDynamic({
    AssetLink? fightingType,
    this.weaponType,
    this.skillMultiplier = 1,
  }) : fightingType = fightingType ?? AssetLink.invalid();
}

class WeaponComponent extends EyuunComponent<int> {
  static const String propertyName = "weapon";

  /// Link to an Asset that describes this weapons fightingType. This asset is a talent and used to gather the value from [SkillLearnerComponent] for this weapon.
  late Entity? fightingType;

  /// Link to an asset with the buff related this weapons Type. Skillcheck is decided by the weapon itself, not through here.
  late Entity? weaponType;

  double skillMultiplier = 1;

  late AttackScope attackScope;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = WeaponDynamicMapper.fromMap(dynamicData);
    fightingType = dyn.fightingType.getEntity();
    weaponType = dyn.weaponType?.getEntity();
    skillMultiplier = dyn.skillMultiplier;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = WeaponStaticMapper.fromMap(staticData);
    fightingType = stat.fightingType.getEntity();
    skillMultiplier = stat.skillMultiplier;
  }

  @override
  void reset() {
    weaponType = null;
    attackScope = AttackScope.Melee;
    skillMultiplier = 0;
    fightingType = null;
  }

  @override
  Map<String, dynamic> saveDynamicData() => WeaponDynamic(
    fightingType: fightingType?.asAssetLink(),
    weaponType: weaponType?.asAssetLink(),
  ).toMap();
}
