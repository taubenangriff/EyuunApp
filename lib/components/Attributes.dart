import 'package:flexbackend/core/components/EyuunComponent.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../core/UpgradableInt.dart';
import '../core/assetLink.dart';
import '../enums/dice.dart';

part 'Attributes.mapper.dart';

@MappableClass()
class AttributesDynamic with AttributesDynamicMappable {
  List<AttributeEntry> statValues;
  AttributesDynamic(this.statValues);
}

@MappableClass()
class AttributesStatic with AttributesStaticMappable {
  List<AssetLink> statValues;
  int defaultDiceIncreases;
  AttributesStatic(this.statValues, this.defaultDiceIncreases);
}

@MappableClass()
class AttributeEntry with AttributeEntryMappable {
  AssetLink stat;
  Dice dice;

  AttributeEntry(this.stat, this.dice);
}

class AttributesComponent extends EyuunComponent<int> {
  static const String propertyName = "attributes";

  late List<AttributeEntry> statValues;
  late UpgradableInt maxDiceIncreases;

  AttributeEntry? getStatEntry(String attributeName){
    return statValues.firstWhere((e) => e.stat.id == attributeName, orElse: null);
  }

  @override
  String getName() => propertyName;

  @override
  void init([data]) {
    reset();
  }

  @override
  void reset() {
    statValues = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() {
    return AttributesDynamic(statValues).toMap();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = AttributesDynamicMapper.fromMap(dynamicData);
    statValues = dyn.statValues;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = AttributesStaticMapper.fromMap(staticData);
    statValues = stat.statValues.map((e) => AttributeEntry(e, Dice.d4)).toList();
    maxDiceIncreases = stat.defaultDiceIncreases.upgradable;
  }

}