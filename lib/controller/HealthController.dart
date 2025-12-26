import 'dart:math';

import 'package:EyuunApp/components/Armor.dart';
import 'package:EyuunApp/components/Attributes.dart';
import 'package:EyuunApp/components/Combat.dart';
import 'package:EyuunApp/components/DamageType.dart';
import 'package:EyuunApp/components/feature/CombatFeature.dart';
import 'package:EyuunApp/components/health.dart';
import 'package:EyuunApp/core/services/WorldManager.dart';
import 'package:EyuunApp/core/services/assetloader.dart';
import 'package:EyuunApp/enums/DamageCalculation.dart';
import 'package:oxygen/oxygen.dart';
import 'package:EyuunApp/enums/dice.dart';

import '../core/registerServices.dart';

class DamageSplit {
  int absorbedByTempHealth;
  int absorbedByArmor;
  int absorbedByNaturalArmor;
  int healthChange;

  DamageSplit(this.absorbedByTempHealth, this.absorbedByArmor,
      this.absorbedByNaturalArmor, this.healthChange);
}

abstract class DamageCalculator {
  DamageSplit getDamage(
      int damage, int armorWorn, int armorNatural, int tempHealth,
      [double proneFactor = 1.0]);
}

class NormalDamageCalculator extends DamageCalculator {
  @override
  DamageSplit getDamage(
      int damage, int armorWorn, int armorNatural, int tempHealth,
      [double proneFactor = 1.0]) {
    int damageAfterWornArmor =
        damage - min(damage, armorWorn);
    int damageAfterNaturalArmor =
        damageAfterWornArmor - min(damageAfterWornArmor, armorNatural);
    int damageAfterProneFactor = (damageAfterNaturalArmor * proneFactor).round();
    int damageAfterTempHealth = damageAfterProneFactor - min(damageAfterProneFactor, tempHealth);

    return DamageSplit(
        min(damage, tempHealth),
        min(damageAfterTempHealth, armorWorn),
        min(damageAfterWornArmor, armorNatural),
        damageAfterTempHealth);
  }
}

class ArmorPenDamageCalculator extends DamageCalculator {
  final NormalDamageCalculator _normalDamageCalculator =
      NormalDamageCalculator();
  @override
  DamageSplit getDamage(
      int damage, int armorWorn, int armorNatural, int tempHealth,
      [double proneFactor = 1.0]) {
    armorWorn = (armorWorn / 2).floor();
    armorNatural = (armorNatural / 2).floor();
    return _normalDamageCalculator.getDamage(
        damage, armorWorn, armorNatural, tempHealth);
  }
}

class IgnoreArmorDamageCalculator extends DamageCalculator {
  final NormalDamageCalculator _normalDamageCalculator =
      NormalDamageCalculator();
  @override
  DamageSplit getDamage(
      int damage, int armorWorn, int armorNatural, int tempHealth,
      [double proneFactor = 1.0]) {
    return _normalDamageCalculator.getDamage(damage, 0, 0, tempHealth);
  }
}

class IgnoreWornArmorDamageCalculator extends DamageCalculator {
  final NormalDamageCalculator _normalDamageCalculator =
      NormalDamageCalculator();
  @override
  DamageSplit getDamage(
      int damage, int armorWorn, int armorNatural, int tempHealth,
      [double proneFactor = 1.0]) {
    return _normalDamageCalculator.getDamage(
        damage, 0, armorNatural, tempHealth);
  }
}

class UnoReverseCardArmorDamageCalculator extends DamageCalculator {
  final IgnoreArmorDamageCalculator _ignoreArmorDamageCalculator =
      IgnoreArmorDamageCalculator();
  @override
  DamageSplit getDamage(
      int damage, int armorWorn, int armorNatural, int tempHealth,
      [double proneFactor = 1.0]) {
    damage = damage + armorWorn;
    return _ignoreArmorDamageCalculator.getDamage(
        damage, armorWorn, armorNatural, tempHealth);
  }
}

class HealthController {
  late CombatFeatureComponent combatFeature;

  late Entity damageType;
  late Entity damageTarget;

  final Map<DamageCalculation, DamageCalculator> _calculators = {
    DamageCalculation.Normal: NormalDamageCalculator(),
    DamageCalculation.IgnoreArmor: ArmorPenDamageCalculator(),
    DamageCalculation.IgnoreHalfArmor: ArmorPenDamageCalculator(),
    DamageCalculation.IgnoreWornArmor: IgnoreWornArmorDamageCalculator(),
    DamageCalculation.UnoReverseCardArmor: UnoReverseCardArmorDamageCalculator()
  };

  HealthController() {
    combatFeature = locator<CombatFeatureComponent>();
  }

  void setDamageTarget(Entity entity) {
    assert(entity.has<HealthComponent>());
  }

  void setDamageType(Entity entity) {
    assert(entity.has<DamageTypeComponent>());
  }

  DamageSplit getDamage(int damage) {
    assert(damageType.has<DamageTypeComponent>());
    assert(damageTarget.has<HealthComponent>());

    var damageCalculation =
        damageType.get<DamageTypeComponent>()!.damageCalculation;
    var calculator = _calculators[damageCalculation] ?? NormalDamageCalculator();

    var armorNatural = 0;
    var tempHealth = 0;

    var armorWorn = damageTarget
            .get<CombatComponent>()
            ?.armor
            ?.getEntity()
            .get<ArmorComponent>()
            ?.armorToughness
            .current ??
        0;

    return calculator.getDamage(damage, armorWorn, armorNatural, tempHealth);
  }
}
