import 'dart:core';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/objectLink.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';

part 'ActionUser.mapper.dart';

@MappableClass()
@reflector
class ActionUserStatic with ActionUserStaticMappable, ComponentReflectable {
  List<AssetLink> defaultActions;
  ActionUserStatic(this.defaultActions);
}

class ActionUserComponent extends EyuunComponent<int> {
  static const String propertyName = "actionUser";

  late List<AssetLink> defaultActions;

  /// filled by ActionSystem.dart
  List<ObjectLink> actionsThroughObjects = [];
  /// filled by ActionSystem.dart
  List<AssetLink> actionsThroughAssets = [];

  List<Entity> getActions() => defaultActions.getAssets() + actionsThroughAssets.getAssets() + actionsThroughObjects.getObjects();

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // nothing to load here
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = ActionUserStaticMapper.fromMap(staticData);
    defaultActions = stat.defaultActions;
  }

  @override
  void reset() {
    defaultActions = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}