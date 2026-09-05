import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

part 'Nameable.mapper.dart';

@MappableClass()
class NameableDynamic with NameableDynamicMappable {
  final String name;

  NameableDynamic({this.name = ''});
}

@reflector
class NameableComponent extends EyuunComponent<String> {
  static const String propertyName = 'nameable';

  String name = '';

  @override
  String getName() => propertyName;

  @override
  void init([String? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    name = NameableDynamicMapper.fromMap(dynamicData).name;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {}

  @override
  void reset() {
    name = '';
  }

  @override
  Map<String, dynamic> saveDynamicData() => NameableDynamic(name: name).toMap();
}
