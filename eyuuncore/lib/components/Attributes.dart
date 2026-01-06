import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../core/UpgradableInt.dart';
import '../core/assetLink.dart';
import '../core/reflection/Reflecting.dart';
import '../enums/dice.dart';

part 'Attributes.mapper.dart';

@MappableClass()
class AttributesDynamic with AttributesDynamicMappable {
  List<AttributeEntry> statValues;
  AttributesDynamic(this.statValues);
}

@MappableClass()
@reflector
class AttributesStatic with AttributesStaticMappable, ComponentReflectable {
  List<AssetLink> statValues;
  int defaultDiceIncreases;
  AttributesStatic(this.statValues, this.defaultDiceIncreases);
}

@MappableClass()
class AttributeEntry with AttributeEntryMappable {
  /// Link to the attribute Asset
  AssetLink stat;

  /// the Dice used to roll on this attribute
  Dice dice;

  AttributeEntry(this.stat, this.dice);
}

class AttributesComponent extends EyuunComponent<int> {
  static const String propertyName = "attributes";

  /// the list of attributes a character has learned.
  late List<AttributeEntry> statValues;

  /// (Upgradable) the total number of Dice increases this character can spend on upgrading stats.
  late UpgradableInt maxDiceIncreases;

  /// Gets the AttributeEntry for the attribute which's typeId matches attributeKey.
  AttributeEntry? getStatEntry(String attributeKey){
    return statValues.firstWhere((e) => e.stat.id == attributeKey, orElse: null);
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