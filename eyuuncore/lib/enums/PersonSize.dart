import 'package:dart_mappable/dart_mappable.dart';

part 'PersonSize.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum PersonSize { Normal, Small, VerySmall }

extension PersonSizeSpeedExtension on PersonSize {
  int getSpeed(){
    return switch (this){
      PersonSize.Normal => 6,
      PersonSize.Small => 5,
      PersonSize.VerySmall => 4,
    };
  }
}