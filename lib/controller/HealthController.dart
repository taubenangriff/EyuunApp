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

abstract class DamageCalculator {
  int getAbsorbedByTempHealth(int damage, int tempHealth);

  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural);
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

class ArmorPenDamageCalculator extends NormalDamageCalculator {
  @override
  int getAbsorbedByArmor(int damage, int armorWorn, int armorNatural) => min(damage, (armorWorn + armorNatural / 2).floor());
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

  late Entity damageType;
  late Entity damageTarget;

  late DamageTypeComponent _damageTypeComponent;
  late HealthComponent _targetHealthComponent;
  late CombatComponent? _targetCombatComponent;

  int absorbedByTempHealth = 0;
  int absorbedByArmor = 0;
  int healthChange = 0;

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
    _targetHealthComponent = entity.get<HealthComponent>()!;
    _targetCombatComponent = entity.get<CombatComponent>();
  }

  void setDamageType(Entity entity) {
    assert(entity.has<DamageTypeComponent>());
    _damageTypeComponent = entity.get<DamageTypeComponent>()!;
  }

  void recalculate(int damage) {
    var calculator = _calculators[_damageTypeComponent.damageCalculation] ?? NormalDamageCalculator();

    var armorNatural = 0;
    var tempHealth = 0;

    var armorWorn = _targetCombatComponent
            ?.armor
            ?.getEntity()
            .get<ArmorComponent>()
            ?.armorToughness
            .current ??
        0;

    double proneFactor = 1.0;

    absorbedByArmor = calculator.getAbsorbedByArmor(damage, armorWorn, armorNatural);
    var damageAfterProne = calculator.getDamageAfterProneFactor(damage - absorbedByArmor, proneFactor);
    absorbedByTempHealth = calculator.getAbsorbedByTempHealth(damageAfterProne, tempHealth);
    healthChange = damageAfterProne - absorbedByTempHealth;
  }
}
