import 'package:dart_mappable/dart_mappable.dart';

part 'dice.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum Dice { d2, d4, d6, d8, d10, d12, d20, d100 }