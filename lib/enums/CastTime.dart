import 'package:dart_mappable/dart_mappable.dart';

part 'CastTime.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum CastTime { None, Action, Reaction, ActionAndReaction, Time }