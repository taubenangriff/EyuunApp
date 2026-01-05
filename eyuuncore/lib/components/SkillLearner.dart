import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../core/UpgradableInt.dart';
import '../core/assetLink.dart';

part 'SkillLearner.mapper.dart';

@MappableClass()
class SkillEntry with SkillEntryMappable {
  AssetLink skill;
  int value;

  SkillEntry(this.skill, this.value);
}

@MappableClass()
class SkillLearnerDynamic with SkillLearnerDynamicMappable {
  int skillpoints;
  int skillCeiling;
  List<SkillEntry> skills;

  SkillLearnerDynamic(this.skillpoints, this.skillCeiling, this.skills);
}

@MappableClass()
@reflector
class SkillLearnerStatic with SkillLearnerStaticMappable, ComponentReflectable {
  List<AssetLink> skills;
  SkillLearnerStatic(this.skills);
}

class SkillLearnerComponent extends EyuunComponent<int> {
  static const String propertyName = "skillLearner";

  /// The amount of skillpoints a character can distribute on talents.
  late UpgradableInt skillpoints;

  /// The cap on a single talent.
  late UpgradableInt skillCeiling;

  /// The list of talents this character uses.
  List<SkillEntry> skills = [];

  /// returns the talentEntry for the Talent listed in key. returns null, if the talent does not exist.
  SkillEntry? getSkill(String key) => skills.firstWhere((e) => e.skill.id == key, orElse: null);

  /// If the talent is present in talents, this function sets it's value to newVal.
  void setSkillValue(String key, int newVal) => getSkill(key)?.value = newVal;

  /// get's a talents skill value or 0 if the talent does not exist in the talents list.
  int getSkillValue(String key) => getSkill(key)?.value ?? 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    skillpoints = 0.upgradable;
    skillCeiling = 0.upgradable;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = SkillLearnerDynamicMapper.fromMap(dynamicData);
    //full outer join the lists without duplicates
    skills.removeWhere((x) => dyn.skills.any((y) => x.skill.id == y.skill.id));
    skills.addAll(dyn.skills);
    skillpoints = dyn.skillpoints.upgradable;
    skillCeiling = dyn.skillCeiling.upgradable;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = SkillLearnerStaticMapper.fromMap(staticData);
    skills = stat.skills.map((e) => SkillEntry(e, 0)).toList();
  }

  @override
  void reset() {
    skills = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => SkillLearnerDynamic(skillpoints.base, skillCeiling.base, skills).toMap();

}