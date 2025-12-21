import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/components/Skillcheck.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'CombatShield.mapper.dart';

@MappableClass()
class CombatShieldStatDyn with CombatShieldStatDynMappable {
  AssetLink shieldType;
  CombatShieldStatDyn(this.shieldType);
}

class CombatShieldComponent extends EyuunComponent<int> {
  static const String propertyName = "combatShield";

  /// link to an Asset with [SkillcheckComponent] that decides this shields skillcheck.
  late AssetLink shieldType;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = CombatShieldStatDynMapper.fromMap(dynamicData);
    shieldType = dyn.shieldType;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = CombatShieldStatDynMapper.fromMap(staticData);
    shieldType = stat.shieldType;
  }

  @override
  void reset() {
    shieldType = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => CombatShieldStatDyn(shieldType).toMap();
}