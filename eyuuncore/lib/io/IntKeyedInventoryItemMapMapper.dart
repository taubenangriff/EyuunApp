import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/inventory.dart';

/// Firestore/JSON require String map keys, so int keys must be converted back and forth.
class IntKeyedInventoryItemMapMapper
    extends SimpleMapper<Map<int, InventoryItemDynamic>> {
  const IntKeyedInventoryItemMapMapper();

  @override
  Map<int, InventoryItemDynamic> decode(dynamic value) {
    var map = value as Map;
    return map.map(
      (key, value) => MapEntry(
        int.parse(key as String),
        InventoryItemDynamicMapper.fromMap(value as Map<String, dynamic>),
      ),
    );
  }

  @override
  dynamic encode(Map<int, InventoryItemDynamic> self) {
    return self.map((key, value) => MapEntry(key.toString(), value.toMap()));
  }
}
