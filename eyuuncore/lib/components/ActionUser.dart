import 'dart:core';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/Action.dart';
import 'package:oxygen/oxygen.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';
import '../core/objectLink.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';
import '../core/upgrading/UpgradableList.dart';

part 'ActionUser.mapper.dart';

@MappableClass()
@reflector
class ActionUserStatic with ActionUserStaticMappable, ComponentReflectable {
  List<AssetLink> defaultActions;
  ActionUserStatic({List<AssetLink>? defaultActions}) : defaultActions = defaultActions ?? [];
}

class ActionLink {
  Entity action;
  Entity source;

  hasExternalSource() => action != source;
  ActionLink({required this.action, required Entity? source})
    : source = source ?? action;
}

class ActionUserComponent extends EyuunComponent<int> {
  static const String propertyName = "actionUser";

  late List<ActionLink> _defaultActions;

  /// filled by ActionSystem.dart
  late UpgradableList<ActionLink> actionsThroughEntities;

  List<ActionLink> getActionsWithSource() =>
      _defaultActions + actionsThroughEntities.current;

  List<Entity> getActions() => getActionsWithSource().map((e) => e.action).toList();

  void clearRegisteredActions() {
    actionsThroughEntities.baseList.clear();
  }

  void _addDefaultAction(Entity? entity, {Entity? source}) {
    if (entity == null) {
      return;
    }
    _defaultActions.add(ActionLink(action: entity, source: source ?? entity));
  }

  void addAction(Entity? entity, {Entity? source}) {
    if (entity == null) {
      return;
    }
    actionsThroughEntities.add(
      ActionLink(action: entity, source: source ?? entity),
    );
  }

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
    for (var link in stat.defaultActions) {
      var entity = link.getEntity();
      _addDefaultAction(entity);
    }
  }

  @override
  void reset() {
    _defaultActions = [];
    actionsThroughEntities = <ActionLink>[].upgradable;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
