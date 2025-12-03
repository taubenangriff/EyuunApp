import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/UpgradableInt.dart';
import 'package:flexbackend/core/components/EyuunComponent.dart';

import '../core/objectLink.dart';

part 'Combat.mapper.dart';

@MappableClass(ignoreNull: false)
class CombatDynamic with CombatDynamicMappable {
  int speed;
  int evasion;
  int initiative;
  int actionsPerRound;
  int reactionsPerRound;
  int equipmentSlotCount;
  bool isSurprised;
  int remainingActions;
  int remainingReactions;

  List<ObjectLink> equippedItems;

  CombatDynamic(
      this.speed,
      this.evasion,
      this.initiative,
      this.actionsPerRound,
      this.reactionsPerRound,
      this.isSurprised,
      this.remainingActions,
      this.remainingReactions,
      this.equipmentSlotCount,
      this.equippedItems);
}

class CombatComponent extends EyuunComponent<int> {
  static const String propertyName = "combat";

  late UpgradableInt speed;
  late UpgradableInt evasion;
  late UpgradableInt initiative;
  late UpgradableInt actionsPerRound;
  late UpgradableInt reactionsPerRound;
  late int equipmentSlotCount;

  late bool isSurprised;
  late int remainingActions;
  late int remainingReactions;

  /// A list of items held in your hands.
  List<ObjectLink> equippedItems = [];

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = CombatDynamicMapper.fromMap(dynamicData);
    speed = dyn.speed.upgradable;
    evasion = dyn.evasion.upgradable;
    initiative = dyn.initiative.upgradable;
    actionsPerRound = dyn.actionsPerRound.upgradable;
    reactionsPerRound = dyn.reactionsPerRound.upgradable;
    isSurprised = dyn.isSurprised;
    remainingActions = dyn.remainingActions;
    remainingReactions = dyn.remainingReactions;
    equipmentSlotCount = dyn.equipmentSlotCount;
    equippedItems = dyn.equippedItems;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // TODO: implement loadStaticData
  }

  @override
  void reset() {
    speed = 0.upgradable;
    evasion = 0.upgradable;
    initiative = 0.upgradable;
    actionsPerRound = 0.upgradable;
    reactionsPerRound = 0.upgradable;
    equipmentSlotCount = 0;
    isSurprised = false;

    remainingReactions = 0;
    remainingActions = 0;
    equippedItems = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => CombatDynamic(
          speed.base,
          evasion.base,
          initiative.base,
          actionsPerRound.base,
          reactionsPerRound.base,
          isSurprised,
          remainingActions,
          remainingReactions,
          equipmentSlotCount,
          equippedItems)
      .toMap();
}
