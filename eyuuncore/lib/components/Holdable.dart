import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';

import '../core/reflection/reflector.dart';

part 'Holdable.mapper.dart';

@MappableClass()
@reflector
class HoldableStatic with HoldableStaticMappable, ComponentReflectable {
  int equipmentSlotsNeeded;

  HoldableStatic({this.equipmentSlotsNeeded = 0});
}

class HoldableComponent extends EyuunComponent<int> {
  static const String propertyName = "holdable";

  /// The amount of equipment Slots needed to hold this item
  late int equipmentSlotsNeeded;

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
  }

  @override
  void reset() {
    equipmentSlotsNeeded = 0;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}