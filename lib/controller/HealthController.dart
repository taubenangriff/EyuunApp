import 'dart:math';

import 'package:EyuunApp/components/Armor.dart';
import 'package:EyuunApp/components/Combat.dart';
import 'package:EyuunApp/components/DamageType.dart';
import 'package:EyuunApp/components/feature/CombatFeature.dart';
import 'package:EyuunApp/components/health.dart';
import 'package:EyuunApp/components/upgradable.dart';
import 'package:EyuunApp/enums/DamageCalculation.dart';
import 'package:oxygen/oxygen.dart';

import '../core/registerServices.dart';

abstract class DamageCalculator {
  /// The positive amount of damage eaten by the shield
  int getAbsorbedByTempHealth(int damage, int tempHealth);

  /// The positive amount of damage that goes into the armor.
  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural);

  /// The total damage after applying the proneFactor.
  int getDamageAfterProneFactor(int damage, double proneFactor);
}

class NormalDamageCalculator extends DamageCalculator {
  @override
  int getAbsorbedByTempHealth(int damage, int tempHealth) => min(damage, tempHealth);

  @override
  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural) => min(damage, armorWorn + armorNatural);

  @override
  int getDamageAfterProneFactor(int damage, double proneFactor) => (damage * proneFactor).floor();
}

class HealDamageCalculator extends DamageCalculator {
  @override
  int getAbsorbedByTempHealth(int damage, int tempHealth) => 0;

  @override
  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural) => 0;

  @override
  int getDamageAfterProneFactor(int damage, double proneFactor) => damage;

}

class ShieldDamageCalculator extends HealDamageCalculator {
  @override
  int getAbsorbedByTempHealth(int damage, int tempHealth) => damage;
}

class ArmorPenDamageCalculator extends NormalDamageCalculator {
  @override
  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural) => min(damage, ((armorWorn + armorNatural) / 2).floor());
}

class IgnoreArmorDamageCalculator extends NormalDamageCalculator {
  @override
  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural) => 0;
}

class IgnoreWornArmorDamageCalculator extends NormalDamageCalculator {
  @override
  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural) => min(damage, armorNatural);
}

class UnoReverseCardArmorDamageCalculator extends NormalDamageCalculator {
  @override
  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural) => -armorWorn;
}

class HealthController {
  late CombatFeatureComponent combatFeature;

  Entity? damageTypeEntity;
  late Entity damageTarget;

  late DamageTypeComponent damageTypeComponent;
  late HealthComponent _targetHealthComponent;
  late CombatComponent? _targetCombatComponent;

  int tempHealthChange = 0;
  int absorbedByArmor = 0;
  int hitpointChange = 0;
  int newHitpoints = 0;
  int oldHitpoints = 0;
  int newShield = 0;
  int oldShield = 0;
  int totalArmor = 0;

  double proneFactor = 1;

  final DamageCalculator _fallbackCalculator = NormalDamageCalculator();

  final Map<DamageCalculation, DamageCalculator> _calculators = {
    DamageCalculation.Normal: NormalDamageCalculator(),
    DamageCalculation.IgnoreArmor: IgnoreArmorDamageCalculator(),
    DamageCalculation.IgnoreHalfArmor: ArmorPenDamageCalculator(),
    DamageCalculation.IgnoreWornArmor: IgnoreWornArmorDamageCalculator(),
    DamageCalculation.UnoReverseCardArmor: UnoReverseCardArmorDamageCalculator(),
    DamageCalculation.AddShield: ShieldDamageCalculator(),
    DamageCalculation.Heal : HealDamageCalculator()
  };

  HealthController() {
    combatFeature = locator<CombatFeatureComponent>();
    setDamageType(combatFeature.healTypes[0].getEntity()!);
  }

  void _reset() {
    oldHitpoints = _targetHealthComponent.hitpoints;
    oldShield = _targetHealthComponent.shield;
    newHitpoints = _targetHealthComponent.hitpoints;
    newShield = _targetHealthComponent.shield;
    tempHealthChange = 0;
    absorbedByArmor = 0;
    hitpointChange = 0;
    totalArmor = _getWornArmor() + _getNaturalArmor();

    proneFactor = 1;
  }

  void setDamageTarget(Entity entity) {
    assert(entity.has<HealthComponent>());
    _targetHealthComponent = entity.get<HealthComponent>()!;
    _targetCombatComponent = entity.get<CombatComponent>();
    damageTarget = entity;

    _reset();
  }

  void setProneFactor(double val){
    proneFactor = val;
  }

  bool isLosingHealth() => hitpointChange < 0;

  bool armorUsedAgainstTarget() => absorbedByArmor < 0;

  int maxGainable() => 100;

  int maxLosable() => 100;

  void setDamageType(Entity entity) {
    assert(entity.has<DamageTypeComponent>());
    damageTypeComponent = entity.get<DamageTypeComponent>()!;
    damageTypeEntity = entity;
  }

  int _getWornArmor() {
    return _targetCombatComponent
        ?.armor
        ?.getEntity()
        .get<ArmorComponent>()
        ?.armorToughness
        .current ??
        0;
  }

  double _getProneFactor() => 1.0;
  int _getNaturalArmor() => 0;
  int _getTempHealth() => _targetHealthComponent.shield;

  void computeDamageSplit(int hpChange) {
    var damage = -hpChange;
    var calculator = _calculators[damageTypeComponent.damageCalculation] ?? _fallbackCalculator;

    var armorNatural = _getNaturalArmor();
    var tempHealth = _getTempHealth();
    var armorWorn = _getWornArmor();

    totalArmor = armorNatural + armorWorn;

    absorbedByArmor = calculator.getAbsorbedByArmor(damage, armorWorn, armorNatural).toInt();
    var damageAfterProne = calculator.getDamageAfterProneFactor(damage - absorbedByArmor, proneFactor);
    tempHealthChange = calculator.getAbsorbedByTempHealth(damageAfterProne, tempHealth) * -1;
    hitpointChange = (damageAfterProne + tempHealthChange) * -1;
    hitpointChange = max(-_targetHealthComponent.hitpoints, hitpointChange);
    newHitpoints = min(_targetHealthComponent.hitpoints + hitpointChange, _targetHealthComponent.maxHitpoints.current);
    newShield = _targetHealthComponent.shield + tempHealthChange;
  }

  void apply() {
    _targetHealthComponent.hitpoints = newHitpoints;
    _targetHealthComponent.shield = newShield;

    if(damageTypeComponent.degradeArmor && hitpointChange < 0){
      //degrade armor
    }

    if(damageTypeComponent.applyStatusEffect != null) {
      damageTarget.get<UpgradableComponent>()?.applyUpgrade(damageTypeComponent.applyStatusEffect!.id);
    }

    if(hitpointChange < 0 && damageTypeComponent.applyStatusEffectOnHit != null) {
      damageTarget.get<UpgradableComponent>()?.applyUpgrade(damageTypeComponent.applyStatusEffectOnHit!.id);
    }
  }
}
