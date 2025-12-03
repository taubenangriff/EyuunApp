import 'package:flexbackend/core/components/EyuunComponent.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../core/UpgradableInt.dart';
import '../core/assetLink.dart';

part 'Talents.mapper.dart';

@MappableClass()
class TalentEntry with TalentEntryMappable {
  AssetLink talent;
  int value;

  TalentEntry(this.talent, this.value);
}

@MappableClass()
class TalentsDynamic with TalentsDynamicMappable {
  int skillpoints;
  int skillCeiling;
  List<TalentEntry> talents;

  TalentsDynamic(this.skillpoints, this.skillCeiling, this.talents);
}

@MappableClass()
class TalentsStatic with TalentsStaticMappable {
  List<AssetLink> talents;
  TalentsStatic(this.talents);
}

class TalentsComponent extends EyuunComponent<int> {
  static const String propertyName = "talents";

  /// The amount of skillpoints a character can distribute on talents.
  late UpgradableInt skillpoints;

  /// The cap on a single talent.
  late UpgradableInt skillCeiling;

  /// The list of talents this character uses.
  List<TalentEntry> talents = [];

  /// returns the talentEntry for the Talent listed in key. returns null, if the talent does not exist.
  TalentEntry? getTalent(String key) => talents.firstWhere((e) => e.talent.id == key, orElse: null);

  /// If the talent is present in talents, this function sets it's value to newVal.
  void setTalentSkill(String key, int newVal) => getTalent(key)?.value = newVal;

  /// get's a talents skill value or 0 if the talent does not exist in the talents list.
  int getTalentSkill(String key) => getTalent(key)?.value ?? 0;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    skillpoints = 0.upgradable;
    skillCeiling = 0.upgradable;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = TalentsDynamicMapper.fromMap(dynamicData);
    //full outer join the lists without duplicates
    talents.removeWhere((x) => dyn.talents.any((y) => x.talent.id == y.talent.id));
    talents.addAll(dyn.talents);
    skillpoints = dyn.skillpoints.upgradable;
    skillCeiling = dyn.skillCeiling.upgradable;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = TalentsStaticMapper.fromMap(staticData);
    talents = stat.talents.map((e) => TalentEntry(e, 0)).toList();
  }

  @override
  void reset() {
    talents = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => TalentsDynamic(skillpoints.base, skillCeiling.base, talents).toMap();

}