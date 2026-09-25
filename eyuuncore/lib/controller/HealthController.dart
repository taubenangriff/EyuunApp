import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/components/Armor.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/DamageType.dart';
import 'package:eyuuncore/components/feature/CombatFeature.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/enums/DamageCalculation.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

import '../GetIt.dart';

abstract class DamageCalculator {
  double addHitpoints(int damageAfterArmor) => 0;

  double addTempHealth(int damageAfterArmor) => 0;

  double getIgnoredNaturalArmor(int armorNatural) => 0;

  double getIgnoredWornArmor(int armorWorn) => 0;

  double getExtraArmorDamage(int armorNatural, int armorWorn) => 0;
}

class NormalDamageCalculator extends DamageCalculator {}

class HealDamageCalculator extends DamageCalculator {
  @override
  double getIgnoredNaturalArmor(int armorNatural) => armorNatural.toDouble();
  @override
  double getIgnoredWornArmor(int armorWorn) => armorWorn.toDouble();
  @override
  double addHitpoints(int damageAfterArmor) => damageAfterArmor.toDouble();
}

class ShieldDamageCalculator extends HealDamageCalculator {
  @override
  double addHitpoints(int damageAfterArmor) => 0;

  @override
  double addTempHealth(int damageAfterArmor) => damageAfterArmor.toDouble();
}

class ArmorPenDamageCalculator extends NormalDamageCalculator {
  @override
  double getIgnoredNaturalArmor(int armorNatural) => armorNatural / 2;

  double getIgnoredWornArmor(int armorWorn) => armorWorn / 2;
}

class IgnoreArmorDamageCalculator extends NormalDamageCalculator {
  @override
  double getIgnoredNaturalArmor(int armorNatural) => armorNatural.toDouble();
  double getIgnoredWornArmor(int armorWorn) => armorWorn.toDouble();
}

class IgnoreWornArmorDamageCalculator extends NormalDamageCalculator {
  @override
  double getIgnoredWornArmor(int armorWorn) => armorWorn.toDouble();
}

class UnoReverseCardArmorDamageCalculator
    extends IgnoreWornArmorDamageCalculator {
  double getExtraArmorDamage(int armorNatural, int armorWorn) =>
      armorWorn.toDouble();
}

class HealthController {
  late CombatFeatureComponent combatFeature;

  List<DamageTypeComponent> damageTypes = [];
  late Entity damageTarget;

  late HealthComponent _targetHealthComponent;
  late CombatComponent? _targetCombatComponent;

  int tempHealthChange = 0;
  double absorbedByWornArmor = 0;
  double absorbedByNaturalArmor = 0;
  double addTempHealth = 0;
  double addHitpoints = 0;

  int absorbedByArmor = 0;
  int absorbedByTempHealth = 0;
  int hitpointChange = 0;
  int effectiveChange = 0;
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
    DamageCalculation.UnoReverseCardArmor:
        UnoReverseCardArmorDamageCalculator(),
    DamageCalculation.AddShield: ShieldDamageCalculator(),
    DamageCalculation.Heal: HealDamageCalculator(),
  };

  HealthController() {
    combatFeature = locator<CombatFeatureComponent>();
    setDamageTypes([combatFeature.healTypes[0]]);
  }

  void _reset() {
    tempHealthChange = 0;
    absorbedByWornArmor = 0;
    absorbedByNaturalArmor = 0;
    addTempHealth = 0;
    addHitpoints = 0;

    absorbedByArmor = 0;
    absorbedByTempHealth = 0;
    hitpointChange = 0;
    effectiveChange = 0;

    oldHitpoints = _targetHealthComponent.hitpoints;
    oldShield = _targetHealthComponent.temporaryHitpoints;
    newHitpoints = _targetHealthComponent.hitpoints;
    newShield = _targetHealthComponent.temporaryHitpoints;
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

  void setProneFactor(double val) {
    proneFactor = val;
  }

  bool isLosingHealth() => hitpointChange < 0;

  bool armorUsedAgainstTarget() =>
      absorbedByWornArmor + absorbedByNaturalArmor < 0;

  int maxGainable() => 99;

  int maxLosable() => 99;

  void setDamageTypes(List<Entity> entities) {
    var list = <DamageTypeComponent>[];
    for (var entity in entities) {
      assert(entities.isNotEmpty && entity.has<DamageTypeComponent>());
      list.add(entity.get<DamageTypeComponent>()!);
    }
    damageTypes = list;
  }

  int _getWornArmor() {
    return _targetCombatComponent?.armor
            ?.get<ArmorComponent>()
            ?.armorToughness
            .current ??
        0;
  }

  int _getNaturalArmor() => _targetHealthComponent.naturalArmor.current;
  int _getTempHealth() => _targetHealthComponent.temporaryHitpoints;

  void _computeEffectiveArmor() {
    //collect the damage types
    double ignoredWorn = 0;
    double ignoredNatural = 0;

    var armorNatural = _getNaturalArmor();
    var armorWorn = _getWornArmor();

    for (var damageType in damageTypes) {
      var calculator =
          _calculators[damageType.damageCalculation] ?? _fallbackCalculator;
      ignoredWorn += calculator.getIgnoredWornArmor(armorWorn);
      ignoredNatural += calculator.getIgnoredNaturalArmor(armorNatural);
      addHitpoints += calculator.getExtraArmorDamage(armorNatural, armorWorn);
    }

    ignoredWorn = min(ignoredWorn, armorWorn.toDouble());
    ignoredNatural = min(ignoredNatural, armorNatural.toDouble());

    //aggregate ignored armor
    absorbedByWornArmor = armorWorn - ignoredWorn;
    absorbedByNaturalArmor = armorNatural - ignoredNatural;
  }

  void _computeAddedHitpoints(int damageAfterArmor) {
    for (var damageType in damageTypes) {
      var calculator =
          _calculators[damageType.damageCalculation] ?? _fallbackCalculator;
      addHitpoints += calculator.addHitpoints(damageAfterArmor);
      addTempHealth += calculator.addTempHealth(damageAfterArmor);
    }
  }

  void computeHeal(int absChange) {
    addHitpoints = 0;
    addTempHealth = 0;
    _computeAddedHitpoints(absChange);

    absorbedByWornArmor = 0;
    absorbedByNaturalArmor = 0;
    absorbedByArmor = 0;

    newHitpoints = min(
      _targetHealthComponent.hitpoints + addHitpoints.round(),
      _targetHealthComponent.maxHitpoints.current,
    );
    newShield =
        _targetHealthComponent.temporaryHitpoints + addTempHealth.round();

    hitpointChange = oldHitpoints - newHitpoints;
    tempHealthChange = newShield - oldShield;
    effectiveChange = hitpointChange + tempHealthChange;
  }

  void computeDamage(int absChange) {
    addHitpoints = 0;
    addTempHealth = 0;

    _computeEffectiveArmor();
    absorbedByArmor = (absorbedByWornArmor + absorbedByNaturalArmor).round();
    var damageAfterArmor = absChange - absorbedByArmor;
    var damageAfterProneFactor = (damageAfterArmor * proneFactor).round();
    damageAfterProneFactor = max(0, damageAfterProneFactor);
    _computeAddedHitpoints(damageAfterProneFactor);
    var tempHealth = _getTempHealth();

    int damageAfterTempHealth = max(damageAfterProneFactor - tempHealth, 0);
    int absorbedByTempHealth = damageAfterProneFactor - damageAfterTempHealth;

    newShield = tempHealth - absorbedByTempHealth + addTempHealth.round();
    tempHealthChange = newShield - oldShield;

    hitpointChange =
        (damageAfterTempHealth.round()) * -1 + addHitpoints.round();

    hitpointChange = max(
      -_targetHealthComponent.hitpoints,
      hitpointChange,
    ).toInt();

    hitpointChange = min(
      hitpointChange,
      _targetHealthComponent.maxHitpoints.current -
          _targetHealthComponent.hitpoints,
    );
    effectiveChange = hitpointChange + tempHealthChange;

    newHitpoints = min(
      _targetHealthComponent.hitpoints + hitpointChange,
      _targetHealthComponent.maxHitpoints.current,
    );
  }

  void computeDamageSplit(int hpChange) {
    if (hpChange >= 0) {
      computeHeal(hpChange);
    } else {
      computeDamage(-hpChange);
    }
  }

  void apply() {
    _targetHealthComponent.hitpoints = newHitpoints;
    _targetHealthComponent.temporaryHitpoints = newShield;

    if (damageTypes.any((x) => x.degradeArmor) && hitpointChange < 0) {
      //degrade armor
    }

    bool upgradableUpdated = false;
    for (var damageType in damageTypes) {
      if (damageType.applyStatusEffect != null) {
        damageTarget.get<UpgradableComponent>()?.applyUpgrade(
          damageType.applyStatusEffect!,
        );
        upgradableUpdated = true;
      }
    }

    if (hitpointChange < 0) {
      for (var damageType in damageTypes) {
        if (damageType.applyStatusEffectOnHit != null) {
          damageTarget.get<UpgradableComponent>()?.applyUpgrade(
            damageType.applyStatusEffectOnHit!,
          );
          upgradableUpdated = true;
        }
      }
    }

    if (upgradableUpdated && damageTarget.has<UpgradableComponent>()) {
      locator<EventBus>().fire(
        EntityUpdatedEvent(
          damageTarget,
          damageTarget.get<UpgradableComponent>()!,
        ),
      );
    }

    locator<EventBus>().fire(
      EntityUpdatedEvent(damageTarget, _targetHealthComponent),
    );
  }
}
