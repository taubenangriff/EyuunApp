import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../core/assetLink.dart';
import '../core/components/EyuunComponent.dart';

part 'Skillcheck.mapper.dart';

@MappableClass()
class SkillcheckOption with SkillcheckOptionMappable {
  List<AssetLink> options;
  AssetLink selectedOption;
  SkillcheckOption(this.options, this.selectedOption);
}

@MappableClass()
class SkillcheckStaticOption with SkillcheckStaticOptionMappable {
  List<AssetLink> options;
  SkillcheckStaticOption(this.options);
}

@MappableClass()
@reflector
class SkillcheckStatic with SkillcheckStaticMappable, ComponentReflectable {
  AssetLink? overrideTalentValue;
  AssetLink? overrideSkillcheck;
  List<SkillcheckStaticOption> checkedAttributes;
  SkillcheckStatic({List<SkillcheckStaticOption>? checkedAttributes, this.overrideTalentValue, this.overrideSkillcheck}) : checkedAttributes = checkedAttributes ?? [];
}

@MappableClass()
class SkillcheckDynamic with SkillcheckDynamicMappable {
  List<SkillcheckOption> checkedAttributes;
  SkillcheckDynamic(this.checkedAttributes);
}

class SkillcheckComponent extends EyuunComponent<int> {
  late AssetLink? overrideTalentValue;
  late AssetLink? overrideSkillcheck;

  List<SkillcheckOption> _checkedAttributes = [];
  List<SkillcheckOption> get checkedAttributes => overrideSkillcheck?.getEntity()?.get<SkillcheckComponent>()?.checkedAttributes ?? _checkedAttributes;

  static const String propertyName = "skillcheck";
  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = SkillcheckDynamicMapper.fromMap(dynamicData);
    _checkedAttributes = dyn.checkedAttributes;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = SkillcheckStaticMapper.fromMap(staticData);
    _checkedAttributes = stat.checkedAttributes.map((e) => SkillcheckOption(e.options, e.options.first)).toList();
    overrideSkillcheck = stat.overrideSkillcheck;
    overrideTalentValue = stat.overrideTalentValue;
  }

  @override
  void reset() {
    _checkedAttributes = [];
    overrideSkillcheck = AssetLink.invalid();
    overrideTalentValue = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => SkillcheckDynamic(_checkedAttributes).toMap();

}