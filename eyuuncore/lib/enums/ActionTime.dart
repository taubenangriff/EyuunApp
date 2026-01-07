import 'package:dart_mappable/dart_mappable.dart';

part 'ActionTime.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum ActionTime { None, Action, Reaction, ActionAndReaction, Time, Attack, Defend }

extension TextExtension on ActionTime {
  getTextKey() {
    return switch (this) {

      // TODO: Handle this case.
      ActionTime.None => "uitext_actiontime_none",
      // TODO: Handle this case.
      ActionTime.Action => "uitext_actiontime_action",
      // TODO: Handle this case.
      ActionTime.Reaction  => "uitext_actiontime_reaction",
      // TODO: Handle this case.
      ActionTime.ActionAndReaction  => "uitext_actiontime_round",
      // TODO: Handle this case.
      ActionTime.Time  => "uitext_actiontime_time",
      // TODO: Handle this case.
      ActionTime.Attack  => "uitext_actiontime_attack",
      // TODO: Handle this case.
      ActionTime.Defend  => "uitext_actiontime_defend",
      _ => ""
    };
  }
}