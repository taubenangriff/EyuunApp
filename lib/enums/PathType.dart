import 'package:dart_mappable/dart_mappable.dart';
part 'PathType.mapper.dart';

@MappableEnum(mode: ValuesMode.named)
enum PathType {
  Flux,
  Fighter,
  Acolyte,
  Crafter,
}