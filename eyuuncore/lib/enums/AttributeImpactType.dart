import 'package:dart_mappable/dart_mappable.dart';

part 'AttributeImpactType.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum AttributeImpactType {
  LanguagePotential,
  Evasion,
  NaturalArmor,
  Health,
  Flux,
  Inventory,
}
