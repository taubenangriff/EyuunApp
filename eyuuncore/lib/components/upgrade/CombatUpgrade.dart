import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import '../../core/components/EyuunComponent.dart';

part 'CombatUpgrade.mapper.dart';

@MappableClass()
@reflector
class CombatUpgradeStatDyn with CombatUpgradeStatDynMappable, ComponentReflectable {
  int speedUpgrade;
  int evasionUpgrade;
  int initiativeUpgrade;
  int actionsPerRoundUpgrade;
  int reactionsPerRoundUpgrade;
  CombatUpgradeStatDyn(
      [this.speedUpgrade = 0,
      this.evasionUpgrade = 0,
      this.initiativeUpgrade = 0,
      this.actionsPerRoundUpgrade = 0,
      this.reactionsPerRoundUpgrade = 0]);
}

class CombatUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "combatUpgrade";

  int speedUpgrade = 0;
  int evasionUpgrade = 0;
  int initiativeUpgrade = 0;
  int actionsPerRoundUpgrade = 0;
  int reactionsPerRoundUpgrade = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    speedUpgrade = 0;
    evasionUpgrade = 0;
    initiativeUpgrade = 0;
    actionsPerRoundUpgrade = 0;
    reactionsPerRoundUpgrade = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) =>
      loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = CombatUpgradeStatDynMapper.fromMap(staticData);
    speedUpgrade = stat.speedUpgrade;
    evasionUpgrade = stat.evasionUpgrade;
    initiativeUpgrade = stat.initiativeUpgrade;
    actionsPerRoundUpgrade = stat.actionsPerRoundUpgrade;
    reactionsPerRoundUpgrade = stat.reactionsPerRoundUpgrade;
  }

  @override
  Map<String, dynamic> saveDynamicData() => CombatUpgradeStatDyn(
          speedUpgrade,
          evasionUpgrade,
          initiativeUpgrade,
          actionsPerRoundUpgrade,
          reactionsPerRoundUpgrade)
      .toMap();
}
