import 'package:dart_mappable/dart_mappable.dart';

part 'TalentGroup.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum TalentGroup { Spellschool, Basic, Advanced, FightingStyle }