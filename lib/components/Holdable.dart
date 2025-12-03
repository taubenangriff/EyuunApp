import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/components/EyuunComponent.dart';

part 'Holdable.mapper.dart';

@MappableClass()
class HoldableStatic with HoldableStaticMappable {
  int equipmentSlotsNeeded;
  bool takesArmorSlot;

  HoldableStatic(this.equipmentSlotsNeeded, this.takesArmorSlot);
}

class HoldableComponent extends EyuunComponent<int> {
  static const String propertyName = "holdable";
  late int equipmentSlotsNeeded;
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