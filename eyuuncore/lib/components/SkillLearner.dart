import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:oxygen/oxygen.dart';

import '../core/upgrading/UpgradableInt.dart';
import '../core/assetLink.dart';
import '../core/upgrading/UpgradableList.dart';

part 'SkillLearner.mapper.dart';

class SkillEntry {
  Entity skill;
  int value;
  SkillEntry(this.skill, this.value);

  static SkillEntry? fromDynamic(SkillEntryDynamic e) {
    var entity = e.skill.getEntity();
    if (entity == null) {
      return null;
    }
    return SkillEntry(entity, e.value);
  }
}

@MappableClass()
class SkillEntryDynamic with SkillEntryDynamicMappable {
  AssetLink skill;
  int value;

  SkillEntryDynamic({AssetLink? skill, this.value = 0})
    : skill = skill ?? AssetLink.invalid();

  static SkillEntryDynamic from(SkillEntry skillEntry) {
    return SkillEntryDynamic(
      skill: skillEntry.skill.asAssetLink(),
      value: skillEntry.value,
    );
  }
}

@MappableClass()
class SkillLearnerDynamic with SkillLearnerDynamicMappable {
  int skillpoints;
  int skillCeiling;
  List<SkillEntryDynamic> skills;
  List<AssetLink> spells = [];
  List<AssetLink> tricks = [];

  SkillLearnerDynamic({
    this.skillpoints = 0,
    this.skillCeiling = 0,
    List<SkillEntryDynamic>? skills,
    List<AssetLink>? spells,
    List<AssetLink>? tricks,
  }) : skills = skills ?? [],
       spells = spells ?? [],
       tricks = tricks ?? [];
}

@MappableClass()
@reflector
class SkillLearnerStatic with SkillLearnerStaticMappable, ComponentReflectable {
  List<AssetLink> skills;
  SkillLearnerStatic(List<AssetLink>? skills) : skills = skills ?? [];
}

class SkillLearnerComponent extends EyuunComponent<int> {
  static const String propertyName = "skillLearner";

  /// The amount of skillpoints a character can distribute on talents.
  late UpgradableInt skillpoints;

  /// The cap on a single talent.
  late UpgradableInt skillCeiling;

  /// The list of talents this character uses.
  List<SkillEntry> skills = [];

  late UpgradableList<Entity> spells;
  late UpgradableList<Entity> tricks;

  /// returns the talentEntry for the Talent listed in key. returns null, if the talent does not exist.
  SkillEntry? getSkill(String key) {
    try{
      return skills.firstWhere((e) => e.skill.getTypeId() == key);
    } on StateError {
      return null;
    }
  }


  /// If the talent is present in talents, this function sets it's value to newVal.
  void setSkillValue(String key, int newVal) => getSkill(key)?.value = newVal;

  /// get's a talents skill value or 0 if the talent does not exist in the talents list.
  int getSkillValue(String key) => getSkill(key)?.value ?? 0;

  int getSpentSkillpoints() =>
      skills.map((e) => e.value).reduce((val1, val2) => val1 + val2);

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = SkillLearnerDynamicMapper.fromMap(dynamicData);
    //load dynamic skills
    var dynSkills = dyn.skills
        .map((e) => SkillEntry.fromDynamic(e))
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
    //full outer join the lists without duplicates
    skills.removeWhere(
      (x) => dynSkills.any((y) => x.skill.getTypeId() == y.skill.getTypeId()),
    );
    skills.addAll(dynSkills);
    skillpoints = dyn.skillpoints.upgradable;
    skillCeiling = dyn.skillCeiling.upgradable;
    spells = dyn.spells.getAssets().upgradable;
    tricks = dyn.spells.getAssets().upgradable;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = SkillLearnerStaticMapper.fromMap(staticData);
    skills = stat.skills
        .map((link) => link.getEntity())
        .where((entity) => entity != null)
        .map((entity) => SkillEntry(entity!, 0))
        .toList();
  }

  @override
  void reset() {
    skillpoints = 0.upgradable;
    skillCeiling = 0.upgradable;
    skills = [];
    spells = <Entity>[].upgradable;
    tricks = <Entity>[].upgradable;
  }

  @override
  Map<String, dynamic> saveDynamicData() => SkillLearnerDynamic(
    skillpoints: skillpoints.base,
    skillCeiling: skillCeiling.base,
    skills: skills.map((e) => SkillEntryDynamic.from(e)).toList(),
    spells: spells.baseList.asAssetLinks(),
    tricks: tricks.baseList.asAssetLinks()
  ).toMap();
}
