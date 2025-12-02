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

  late UpgradableInt skillpoints;
  late UpgradableInt skillCeiling;

  List<TalentEntry> talents = [];

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