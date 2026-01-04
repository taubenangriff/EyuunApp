import 'package:dart_mappable/dart_mappable.dart';

part 'DamageCalculation.mapper.dart';

@MappableEnum(mode: ValuesMode.named)

enum DamageCalculation { Normal, IgnoreHalfArmor, IgnoreArmor, IgnoreWornArmor, UnoReverseCardArmor, Heal, AddShield }