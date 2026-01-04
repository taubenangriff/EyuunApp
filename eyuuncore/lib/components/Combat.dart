import 'package:eyuuncore/components/Armor.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/UpgradableInt.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';

import '../core/objectLink.dart';
import 'Holdable.dart';

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
  ObjectLink? armor;

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
      this.equippedItems,
      this.armor);
}

class CombatComponent extends EyuunComponent<int> {
  static const String propertyName = "combat";

  /// walking speed
  late UpgradableInt speed;
  /// bonus on evasion rolls
  late UpgradableInt evasion;
  /// the current initiative roll. Outside combat, this value does not matter.
  late UpgradableInt initiative;
  /// the amount of actions a character can perform per round.
  late UpgradableInt actionsPerRound;
  /// the amount of reactions a character can perform per round.
  late UpgradableInt reactionsPerRound;

  /// the amount of equipmentSlots a character has - this is equivalent to his number of hands to hold items in.
  late int equipmentSlotCount;

  /// is the character currently surprised?
  late bool isSurprised;
  /// how many actions remain in this round
  late int remainingActions;
  /// how many reactions remain in this round
  late int remainingReactions;

  /// The list of items held in your hands.
  List<ObjectLink> equippedItems = [];

  ObjectLink? armor;

  void equipArmor(Entity entity) {
    assert(entity.has<ArmorComponent>());
    armor = ObjectLink.fromEntity(entity);
  }

  void unequipArmor() {
    armor = null;
  }

  bool wearsArmor() => armor != null;
  
  /// gets the amount of equipment Slots that are used by items in equippedItems. 
  int getOccupiedEquipmentSlotCount(){
    var total = 0;
    for(var item in equippedItems){
      total += item.getEntity().get<HoldableComponent>()?.equipmentSlotsNeeded ?? 0;
    }
    return total;
  }

  /// gets whether an item can be equipped in your hand.
  bool canEquipItem(Entity entity){
    var slotsNeeded = entity.get<HoldableComponent>()?.equipmentSlotsNeeded ?? 0;
    return getOccupiedEquipmentSlotCount() <= equipmentSlotCount + slotsNeeded;
  }

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
    armor = dyn.armor;
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
          equippedItems,
          armor)
      .toMap();
}
