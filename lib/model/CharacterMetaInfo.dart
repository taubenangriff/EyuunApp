import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/Nameable.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/enums/CharacterState.dart';

part 'CharacterMetaInfo.mapper.dart';

@MappableClass()
class CharacterMetaInfo with CharacterMetaInfoMappable {
  final String name;
  final String upbringing;
  final int level;
  final DateTime lastModified;
  final String creatorName;
  final Uri? image;
  final CharacterState characterState;

  CharacterMetaInfo({
    required this.name,
    required this.upbringing,
    required this.level,
    required this.lastModified,
    required this.creatorName,
    required this.image,
    required this.characterState,
  });

  static CharacterMetaInfo fromCharacterBaseComponent(
    CharacterBaseComponent characterBase,
    NameableComponent nameable, {
    required DateTime lastModified,
    required String creatorName,
  }) {
    return CharacterMetaInfo(
      name: nameable.name,
      upbringing: characterBase.upbringing?.getTextKey() ?? '',
      level: characterBase.level,
      lastModified: lastModified,
      creatorName: creatorName,
      image: characterBase.image,
      characterState: characterBase.characterState,
    );
  }
}
