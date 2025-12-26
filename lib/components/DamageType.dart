import 'package:EyuunApp/enums/DamageCalculation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'DamageType.mapper.dart';

@MappableClass()
class DamageTypeStatic with DamageTypeStaticMappable {
  DamageCalculation damageCalculation;
  bool degradeArmor;
  AssetLink? applyStatusEffectOnHit;
  AssetLink? applyStatusEffect;
  bool useFreezingLogic;
  int pushback;

  DamageTypeStatic(this.damageCalculation,
      [this.degradeArmor = false,
      this.applyStatusEffectOnHit,
      this.applyStatusEffect,
      this.useFreezingLogic = false,
      this.pushback = 0]);
}

class DamageTypeComponent extends EyuunComponent<int> {
  static const String propertyName = "damageType";

  late DamageCalculation damageCalculation;
  late bool degradeArmor;
  late AssetLink? applyStatusEffectOnHit;
  late AssetLink? applyStatusEffect;
  late bool useFreezingLogic;
  late int pushback;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // nothing to load here
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = DamageTypeStaticMapper.fromMap(staticData);
    damageCalculation = stat.damageCalculation;
    degradeArmor = stat.degradeArmor;
    applyStatusEffectOnHit = stat.applyStatusEffectOnHit;
    applyStatusEffect = stat.applyStatusEffect;
    useFreezingLogic = stat.useFreezingLogic;
    pushback = stat.pushback;
  }

  @override
  void reset() {
    damageCalculation = DamageCalculation.Normal;
    degradeArmor = false;
    applyStatusEffectOnHit = null;
    applyStatusEffect = null;
    useFreezingLogic = false;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
