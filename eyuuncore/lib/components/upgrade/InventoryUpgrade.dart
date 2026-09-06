import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../../core/components/EyuunComponent.dart';

part 'InventoryUpgrade.mapper.dart';

@MappableClass()
@reflector
class InventoryUpgradeStatDyn
    with InventoryUpgradeStatDynMappable, ComponentReflectable {
  int increaseSlotCount;

  InventoryUpgradeStatDyn({this.increaseSlotCount = 0});
}

class InventoryUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = 'inventoryUpgrade';

  int increaseSlotCount = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    increaseSlotCount = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) =>
      loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    final stat = InventoryUpgradeStatDynMapper.fromMap(staticData);
    increaseSlotCount = stat.increaseSlotCount;
  }

  @override
  Map<String, dynamic> saveDynamicData() =>
      InventoryUpgradeStatDyn(increaseSlotCount: increaseSlotCount).toMap();
}
