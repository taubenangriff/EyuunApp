import 'package:dart_mappable/dart_mappable.dart';

import '../../core/assetLink.dart';
import '../../core/components/EyuunComponent.dart';
import '../../core/reflection/reflector.dart';
import '../../core/reflection/Reflecting.dart';
import '../ActionUser.dart';

part 'ActionUserUpgrade.mapper.dart';

@MappableClass()
@reflector
class ActionUserUpgradeStatDyn
    with ActionUserUpgradeStatDynMappable, ComponentReflectable {
  List<AssetLink> addedActions;
  ActionUserUpgradeStatDyn({List<AssetLink>? addedActions})
    : addedActions = addedActions ?? [];
}

class ActionUserUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "actionUserUpgrade";

  List<ActionLink> addedActions = [];

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = ActionUserUpgradeStatDynMapper.fromMap(dynamicData);
    _addEntities(dyn.addedActions);
  }

  void _addEntities(List<AssetLink> link) {
    for (var action in link) {
      var entity = action.getEntity();
      if (entity == null) {
        continue;
      }
      addedActions.add(ActionLink(action: entity, source: entity));
    }
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = ActionUserUpgradeStatDynMapper.fromMap(staticData);
    _addEntities(stat.addedActions);
  }

  @override
  void reset() {
    addedActions = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => ActionUserUpgradeStatDyn(
    addedActions: addedActions
        .map((e) => AssetLink.fromEntity(e.action))
        .toList(),
  ).toMap();
}
