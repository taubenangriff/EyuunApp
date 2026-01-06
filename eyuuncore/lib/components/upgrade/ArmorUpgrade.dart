import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../../core/components/EyuunComponent.dart';
import '../../core/reflection/Reflecting.dart';

part 'ArmorUpgrade.mapper.dart';

@MappableClass()
@reflector
class ArmorUpgradeStatDyn with ArmorUpgradeStatDynMappable, ComponentReflectable {
  int armorToughnessBonus;
  ArmorUpgradeStatDyn([this.armorToughnessBonus = 0]);
}

class ArmorUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "armorUpgrade";

  int armorToughnessBonus = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    armorToughnessBonus = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) => loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = ArmorUpgradeStatDynMapper.fromMap(staticData);
    armorToughnessBonus = stat.armorToughnessBonus;
  }

  @override
  Map<String, dynamic> saveDynamicData() => ArmorUpgradeStatDyn(armorToughnessBonus).toMap();
}