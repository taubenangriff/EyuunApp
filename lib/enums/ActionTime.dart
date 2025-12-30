import 'package:dart_mappable/dart_mappable.dart';

part 'ActionTime.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum ActionTime { None, Action, Reaction, ActionAndReaction, Time, Attack, Defend }