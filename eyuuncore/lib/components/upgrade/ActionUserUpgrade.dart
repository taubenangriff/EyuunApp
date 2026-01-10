import 'package:dart_mappable/dart_mappable.dart';

import '../../core/assetLink.dart';
import '../../core/components/EyuunComponent.dart';
import '../../core/reflection/reflector.dart';
import '../../core/reflection/Reflecting.dart';

part 'ActionUserUpgrade.mapper.dart';

@MappableClass()
@reflector
class ActionUserUpgradeStatDyn with ActionUserUpgradeStatDynMappable, ComponentReflectable {
  List<AssetLink> addedActions;
  ActionUserUpgradeStatDyn({addedActions}) : addedActions = addedActions ?? [];
}

class ActionUserUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "actionUserUpgrade";

  late List<AssetLink> addedActions;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = ActionUserUpgradeStatDynMapper.fromMap(dynamicData);
    addedActions = dyn.addedActions;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = ActionUserUpgradeStatDynMapper.fromMap(staticData);
    addedActions = stat.addedActions;
  }

  @override
  void reset() {
    addedActions = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => ActionUserUpgradeStatDyn(addedActions: addedActions).toMap();
}