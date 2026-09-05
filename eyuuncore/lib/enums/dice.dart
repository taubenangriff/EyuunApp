import 'package:dart_mappable/dart_mappable.dart';

part 'dice.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum Dice { d2, d4, d6, d8, d10, d12, d20, d100 }

extension DiceText on Dice {
  String getText() {
    return switch (this) {
      Dice.d100 => "00",
      _ => getValue().toString(),
    };
  }

  int getUpgrades() {
    return switch (this) {
      Dice.d2 => 0,
      Dice.d4 => 0,
      Dice.d6 => 1,
      Dice.d8 => 2,
      Dice.d10 => 3,
      Dice.d12 => 4,
      Dice.d20 => 5,
      Dice.d100 => 6,
    };
  }

  int getValue() {
    return switch (this) {
      Dice.d2 => 2,
      Dice.d4 => 4,
      Dice.d6 => 6,
      Dice.d8 => 8,
      Dice.d10 => 10,
      Dice.d12 => 12,
      Dice.d20 => 20,
      Dice.d100 => 100,
    };
  }
}
