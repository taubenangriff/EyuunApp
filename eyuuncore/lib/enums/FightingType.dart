import 'package:dart_mappable/dart_mappable.dart';

part 'FightingType.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum AttackScope { Melee, Ranged, Area }