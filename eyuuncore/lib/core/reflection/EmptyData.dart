import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

part 'EmptyData.mapper.dart';

@MappableClass()
@reflector
class EmptyData with EmptyDataMappable, ComponentReflectable {
  EmptyData();
}