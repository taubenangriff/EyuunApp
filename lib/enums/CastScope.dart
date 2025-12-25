import 'package:dart_mappable/dart_mappable.dart';

part 'CastScope.mapper.dart';

@MappableEnum(mode: ValuesMode.named)

enum CastScope {
  Self,
  Sight,
  SightRadius,
  Touch,
  Aura,
  Rectangle,
  Cone,
  Cuboid,
  Variant
}
