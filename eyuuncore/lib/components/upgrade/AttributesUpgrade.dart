import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import '../../core/components/EyuunComponent.dart';

part 'AttributesUpgrade.mapper.dart';

@MappableClass()
@reflector
class AttributesUpgradeStatDyn with AttributesUpgradeStatDynMappable, ComponentReflectable {
  int maxDiceIncreasesUpgrade;
  AttributesUpgradeStatDyn([this.maxDiceIncreasesUpgrade = 0]);
}

class AttributesUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "attributesUpgrade";

  int maxDiceIncreasesUpgrade = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    maxDiceIncreasesUpgrade = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) => loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = AttributesUpgradeStatDynMapper.fromMap(staticData);
    maxDiceIncreasesUpgrade = stat.maxDiceIncreasesUpgrade;
  }

  @override
  Map<String, dynamic> saveDynamicData() => AttributesUpgradeStatDyn(maxDiceIncreasesUpgrade).toMap();
}