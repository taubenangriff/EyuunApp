import 'package:eyuuncore/core/reflection/reflector.dart';

import '../reflection/Reflecting.dart';

class ComponentRepository{
  final Map<String, Reflecting Function(Map<String, dynamic>)> _fromMap= {};
  final Map<Type, String> _typeKeys = {};

  ComponentRepository();

  void registerComponent<T>(String name, Reflecting Function(Map<String, dynamic>) fromMap) {
    _fromMap[name] = fromMap;
    _typeKeys[T] = name;
  }

  bool isComponent(String name) => _fromMap.keys.contains(name);

  Reflecting? fromMap(String name, Map<String, dynamic> map) => _fromMap[name]?.call(map);
}