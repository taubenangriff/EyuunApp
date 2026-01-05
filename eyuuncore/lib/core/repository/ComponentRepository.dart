import 'package:eyuuncore/core/reflection/reflector.dart';

import '../reflection/Reflecting.dart';

class ComponentRepository{
  final Map<String, ComponentReflectable Function(Map<String, dynamic>)> _fromMap= {};
  final Map<String, Map<String, dynamic> Function(ComponentReflectable)> _toMap= {};
  final Map<Type, String> _typeKeys = {};

  ComponentRepository();

  void registerComponent<T extends ComponentReflectable>(String name, ComponentReflectable Function(Map<String, dynamic>) fromMap, Map<String, dynamic> Function(T) toMap) {
    _fromMap[name] = fromMap;
    _toMap[name] = (e) => toMap(e as T);
    _typeKeys[T] = name;
  }

  String? getKey(Type type) => _typeKeys[type];

  bool isComponent(String name) => _fromMap.keys.contains(name);

  ComponentReflectable? fromMap(String name, Map<String, dynamic> map) => _fromMap[name]?.call(map);

  Map<String, dynamic> toMap(ComponentReflectable reflecting) => _toMap[getKey(reflecting.runtimeType)]?.call(reflecting) ?? {};
}