import 'package:dart_mappable/dart_mappable.dart';

part 'PersonSize.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum PersonSize { Normal, Small, VerySmall, Tiny, Big, Huge, Giant }

extension PersonSizeSpeedExtension on PersonSize {
  int getSpeed() {
    return switch (this) {
      PersonSize.Normal => 6,
      PersonSize.Small => 5,
      PersonSize.VerySmall => 4,
      PersonSize.Tiny => 3,
      PersonSize.Big => 7,
      PersonSize.Huge => 8,
      PersonSize.Giant => 9,
    };
  }

  String getTextKey() {
    return switch (this) {
      PersonSize.Normal => 'personsize_normal',
      PersonSize.Small => 'personsize_small',
      PersonSize.VerySmall => 'personsize_verysmall',
      PersonSize.Tiny => 'personsize_tiny',
      PersonSize.Big => 'personsize_big',
      PersonSize.Huge => 'personsize_huge',
      PersonSize.Giant => 'personsize_giant',
    };
  }
}
