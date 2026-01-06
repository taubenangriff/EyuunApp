import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../../core/components/EyuunComponent.dart';

part 'TalentsUpgrade.mapper.dart';

@MappableClass()
@reflector
class TalentsUpgradeStatDyn with TalentsUpgradeStatDynMappable, ComponentReflectable {
  int addSkillpoints;
  int skillCeilingUpgrade;
  TalentsUpgradeStatDyn([this.addSkillpoints = 0, this.skillCeilingUpgrade = 0]);
}

class TalentsUpgradeComponent extends EyuunComponent<int> {
  static const String propertyName = "talentsUpgrade";

  int addSkillpoints = 0;
  int skillCeilingUpgrade = 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    addSkillpoints = 0;
    skillCeilingUpgrade = 0;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) => loadStaticData(dynamicData);

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = TalentsUpgradeStatDynMapper.fromMap(staticData);
    addSkillpoints = stat.addSkillpoints;
    skillCeilingUpgrade = stat.skillCeilingUpgrade;
  }

  @override
  Map<String, dynamic> saveDynamicData() => TalentsUpgradeStatDyn(addSkillpoints, skillCeilingUpgrade).toMap();
}