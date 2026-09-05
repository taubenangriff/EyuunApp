import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:oxygen/oxygen.dart';

import '../core/upgrading/UpgradableInt.dart';
import '../core/assetLink.dart';
import '../core/reflection/Reflecting.dart';
import '../enums/dice.dart';
import 'package:collection/collection.dart';

part 'Attributes.mapper.dart';

@MappableClass()
class AttributesDynamic with AttributesDynamicMappable {
  List<AttributeEntryStatic> statValues;
  AttributesDynamic({List<AttributeEntryStatic>? statValues})
    : statValues = statValues ?? [];
}

@MappableClass()
@reflector
class AttributesStatic with AttributesStaticMappable, ComponentReflectable {
  List<AssetLink> statValues;
  int defaultDiceIncreases;
  AttributesStatic({List<AssetLink>? statValues, this.defaultDiceIncreases = 0})
    : statValues = statValues ?? [];
}

@MappableClass()
class AttributeEntryStatic with AttributeEntryStaticMappable {
  /// Link to the attribute Asset
  AssetLink stat;

  /// the Dice used to roll on this attribute
  Dice dice;

  AttributeEntryStatic(this.stat, this.dice);

  static AttributeEntryStatic from(AttributeEntry e) {
    return AttributeEntryStatic(AssetLink.fromEntity(e.stat), e.dice);
  }
}

class AttributeEntry {
  Entity stat;
  Dice dice;
  AttributeEntry(this.stat, this.dice);

  static AttributeEntry? fromStatic(AttributeEntryStatic e) {
    var entity = e.stat.getEntity();
    if (entity == null) {
      return null;
    }
    return AttributeEntry(entity, e.dice);
  }
}

class AttributesComponent extends EyuunComponent<int> {
  static const String propertyName = "attributes";

  /// the list of attributes a character has learned.
  late List<AttributeEntry> statValues;

  /// (Upgradable) the total number of Dice increases this character can spend on upgrading stats.
  late UpgradableInt maxDiceIncreases;

  int spentUpgrades = 0;

  /// Gets the AttributeEntry for the attribute which's typeId matches attributeKey.
  AttributeEntry? getStatEntry(String attributeKey) {
    return statValues.firstWhere(
      (e) => e.stat.getTypeId() == attributeKey,
      orElse: null,
    );
  }

  void _updateSpentUpgrades() {
    spentUpgrades = statValues
        .map((e) => e.dice.getValue())
        .reduce((a, b) => a + b);
  }

  void setStatEntry(String attributeKey, Dice value) {
    var entry = getStatEntry(attributeKey);
    entry?.dice = value;
    _updateSpentUpgrades();
  }

  int getDiceValue(String attributeKey) {
    return getStatEntry(attributeKey)?.dice.getValue() ?? 0;
  }

  @override
  String getName() => propertyName;

  @override
  void init([data]) {
    reset();
    spentUpgrades = statValues
        .map((e) => e.dice.getValue())
        .reduce((a, b) => a + b);
  }

  @override
  void reset() {
    statValues = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() {
    return AttributesDynamic(
      statValues: statValues.map((e) => AttributeEntryStatic.from(e)).toList(),
    ).toMap();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = AttributesDynamicMapper.fromMap(dynamicData);
    statValues = dyn.statValues
        .map((e) => AttributeEntry.fromStatic(e))
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = AttributesStaticMapper.fromMap(staticData);
    statValues = stat.statValues
        .map((e) => e.getEntity())
        .where((e) => e != null)
        .map((e) => AttributeEntry(e!, Dice.d4))
        .toList();
    maxDiceIncreases = stat.defaultDiceIncreases.upgradable;
  }
}
