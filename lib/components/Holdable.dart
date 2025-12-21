import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

part 'Holdable.mapper.dart';

@MappableClass()
class HoldableStatic with HoldableStaticMappable {
  int equipmentSlotsNeeded;
  bool takesArmorSlot;

  HoldableStatic(this.equipmentSlotsNeeded, this.takesArmorSlot);
}

class HoldableComponent extends EyuunComponent<int> {
  static const String propertyName = "holdable";

  /// The amount of equipment Slots needed to hold this item
  late int equipmentSlotsNeeded;

  /// Whether this equippable takes up the armor Slot.
  late bool takesArmorSlot;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // nothing to load here
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = HoldableStaticMapper.fromMap(staticData);
    equipmentSlotsNeeded = stat.equipmentSlotsNeeded;
    takesArmorSlot = stat.takesArmorSlot;
  }

  @override
  void reset() {
    equipmentSlotsNeeded = 0;
    takesArmorSlot = false;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}