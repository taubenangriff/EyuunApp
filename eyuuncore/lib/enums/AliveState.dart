import 'package:dart_mappable/dart_mappable.dart';

part 'AliveState.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum AliveState { Healthy, Stabilized, Dying, Dead }

extension TextExtension on AliveState {
  getTextKey() {
    return switch (this) {
      AliveState.Dying => "",
      AliveState.Healthy => "",
      AliveState.Stabilized => "",
      AliveState.Dead => "",
    };
  }
}