import 'package:dart_mappable/dart_mappable.dart';

part 'CharacterState.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum CharacterState { InCreation, Ingame }

extension TextExtension on CharacterState {
  getTextKey() {
    return switch (this) {
      CharacterState.InCreation => "",
      CharacterState.Ingame => "",
    };
  }
}
