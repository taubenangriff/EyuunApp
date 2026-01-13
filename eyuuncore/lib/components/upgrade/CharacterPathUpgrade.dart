import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../../core/components/EyuunComponent.dart';

part 'CharacterPathUpgrade.mapper.dart';

@MappableClass()
@reflector
class CharacterPathUpgradeStatDyn
    with CharacterPathUpgradeStatDynMappable, ComponentReflectable {
  int pathCapacityUpgrade;
  int additionalPathCapacityUpgrade;
  CharacterPathUpgradeStatDyn({
    this.pathCapacityUpgrade = 0,
    this.additionalPathCapacityUpgrade = 0,
  });
}

class CharacterPathUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "characterPathUpgrade";

  int pathCapacityUpgrade = 0;
  int additionalPathCapacityUpgrade = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    pathCapacityUpgrade = 0;
    additionalPathCapacityUpgrade = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) =>
      loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = CharacterPathUpgradeStatDynMapper.fromMap(staticData);
    pathCapacityUpgrade = stat.pathCapacityUpgrade;
    additionalPathCapacityUpgrade = stat.additionalPathCapacityUpgrade;
  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterPathUpgradeStatDyn(
    pathCapacityUpgrade: pathCapacityUpgrade,
  ).toMap();
}
