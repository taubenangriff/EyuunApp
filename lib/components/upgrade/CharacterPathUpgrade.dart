import 'package:dart_mappable/dart_mappable.dart';
import '../../core/components/EyuunComponent.dart';

part 'CharacterPathUpgrade.mapper.dart';

@MappableClass()
class CharacterPathUpgradeStatDyn with CharacterPathUpgradeStatDynMappable {
  int pathCapacityUpgrade;
  CharacterPathUpgradeStatDyn([this.pathCapacityUpgrade = 0]);
}

class CharacterPathUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "characterPathUpgrade";

  int pathCapacityUpgrade = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    pathCapacityUpgrade = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) => loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = CharacterPathUpgradeStatDynMapper.fromMap(staticData);
    pathCapacityUpgrade = stat.pathCapacityUpgrade;
  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterPathUpgradeStatDyn(pathCapacityUpgrade).toMap();
}