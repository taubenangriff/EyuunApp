import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';

part 'Equippable.mapper.dart';

@MappableClass()
//As weapon data needs to be saved for individual items, and all static properties need to also be dynamically saved and loaded, we create a dual-use class for the data mapping.
class EquippableStatDyn with EquippableStatDynMappable, ComponentReflectable {
  int equipmentSlotsNeeded;
  bool isArmor;

  EquippableStatDyn(this.equipmentSlotsNeeded, this.isArmor);
}

class EquippableComponent extends EyuunComponent<int> {
  static const String propertyName = "equippable";

  int equipmentSlotsNeeded = 0;
  bool isArmor = false;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = EquippableStatDynMapper.fromMap(dynamicData);
    isArmor = dyn.isArmor;
    equipmentSlotsNeeded = dyn.equipmentSlotsNeeded;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = EquippableStatDynMapper.fromMap(staticData);
    isArmor = stat.isArmor;
    equipmentSlotsNeeded = stat.equipmentSlotsNeeded;
  }

  @override
  void reset() {
    equipmentSlotsNeeded = 0;
    isArmor = false;
  }

  @override
  Map<String, dynamic> saveDynamicData() =>  EquippableStatDyn(equipmentSlotsNeeded, isArmor).toMap();
}