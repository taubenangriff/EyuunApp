import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';

part 'EmptyData.mapper.dart';

@MappableClass()
class EmptyData with EmptyDataMappable, ComponentReflectable {
  EmptyData();
}