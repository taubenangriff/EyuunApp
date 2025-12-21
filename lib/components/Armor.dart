import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/UpgradableInt.dart';

import '../core/components/EyuunComponent.dart';

part 'Armor.mapper.dart';

@MappableClass()
class ArmorDynamic with ArmorDynamicMappable {
  int evasionImpact;
  int athleticImpact;
  int stealthImpact;

  ArmorDynamic(
      this.evasionImpact,
      this.athleticImpact,
      this.stealthImpact);
}

@MappableClass()
class ArmorStatic with ArmorStaticMappable {
  int armorToughness;

  int splittableImpactOnCraft;
  int evasionImpactOnCraft;
  int athleticImpactOnCraft;
  int stealthImpactOnCraft;

  ArmorStatic(
      this.armorToughness,
      this.splittableImpactOnCraft,
      this.evasionImpactOnCraft,
      this.athleticImpactOnCraft,
      this.stealthImpactOnCraft);
}

class ArmorComponent extends EyuunComponent<int> {
  static const String propertyName = "armor";

  /// The armor value of this armor.
  UpgradableInt armorToughness = 0.upgradable;

  /// The impact that needs to be distributed by the crafter to this armor when crafted.
  int splittableImpactOnCraft = 0;
  /// The fixed impact on evasion applied to this armor when crafted.
  int evasionImpactOnCraft = 0;
  /// The fixed impact on athletic applied to this armor when crafted.
  int athleticImpactOnCraft = 0;
  /// The fixed impact on stealth applied to this armor when crafted.
  int stealthImpactOnCraft = 0;

  /// The impact on stealth of this armor.
  int evasionImpact = 0;
  /// The impact on athletic of this armor.
  int athleticImpact = 0;
  /// The impact on stealth of this armor.
  int stealthImpact = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = ArmorDynamicMapper.fromMap(dynamicData);
    evasionImpact = dyn.evasionImpact;
    athleticImpact = dyn.athleticImpact;
    stealthImpact = dyn.stealthImpact;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = ArmorStaticMapper.fromMap(staticData);
    armorToughness = stat.armorToughness.upgradable;
    splittableImpactOnCraft = stat.splittableImpactOnCraft;
    stealthImpactOnCraft = stat.stealthImpactOnCraft;
    athleticImpactOnCraft = stat.athleticImpactOnCraft;
    evasionImpactOnCraft = stat.evasionImpactOnCraft;
  }

  @override
  void reset() {
    armorToughness = 0.upgradable;
    splittableImpactOnCraft = 0;
    stealthImpactOnCraft = 0;
    athleticImpactOnCraft = 0;
    evasionImpactOnCraft = 0;
    evasionImpact = 0;
    athleticImpact = 0;
    stealthImpact = 0;
  }

  @override
  Map<String, dynamic> saveDynamicData() => ArmorDynamic(evasionImpact, athleticImpact, stealthImpact).toMap();
}
