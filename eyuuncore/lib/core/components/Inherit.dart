import 'package:dart_mappable/dart_mappable.dart';
import '../reflection/reflector.dart';
import '../reflection/Reflecting.dart';

part 'Inherit.mapper.dart';

@MappableClass()
@reflector
class InheritStatic with InheritStaticMappable, ComponentReflectable {
  static const String propertyName = "inherit";

  final String from;

  InheritStatic(this.from);
}