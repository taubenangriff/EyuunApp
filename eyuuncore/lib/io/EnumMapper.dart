import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/enums/AttributeImpactType.dart';
import 'package:eyuuncore/enums/PersonSize.dart';

/// Maps a `Map<T, int>` to and from JSON, using the enum value names as keys.
///
/// Pass `Enum.values` as [values] since the enum type cannot be enumerated at runtime.
class EnumMapper<T extends Enum, T2 extends num>
    extends SimpleMapper<Map<T, T2>> {
  final List<T> values;

  const EnumMapper(this.values);

  /// Ignores keys that are not a name of [T].
  @override
  Map<T, T2> decode(dynamic value) {
    final byName = values.asNameMap();
    final result = <T, T2>{};
    (value as Map).forEach((key, val) {
      final enumValue = byName[key as String];
      if (enumValue != null) result[enumValue] = val as T2;
    });
    return result;
  }

  @override
  dynamic encode(Map<T, T2> self) =>
      self.map((key, value) => MapEntry(key.name, value));
}

class PersonSizeIntMapper extends EnumMapper<PersonSize, int> {
  const PersonSizeIntMapper() : super(PersonSize.values);
}

class AttributeImpactTypeDoubleMapper
    extends EnumMapper<AttributeImpactType, double> {
  const AttributeImpactTypeDoubleMapper() : super(AttributeImpactType.values);
}
