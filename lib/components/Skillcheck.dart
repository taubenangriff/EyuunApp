import '../core/components/EyuunComponent.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'Skillcheck.mapper.dart';

@MappableClass()
class SkillcheckOption with SkillcheckOptionMappable {
  List<String> options;
  int selectedOption;
  SkillcheckOption(this.options, this.selectedOption);
}

@MappableClass()
class SkillcheckStaticOption with SkillcheckStaticOptionMappable {
  List<String> options;
  SkillcheckStaticOption(this.options);
}

@MappableClass()
class SkillcheckStatic with SkillcheckStaticMappable {
  List<SkillcheckStaticOption> checkedAttributes;
  SkillcheckStatic(this.checkedAttributes);
}

@MappableClass()
class SkillcheckDynamic with SkillcheckDynamicMappable {
  List<SkillcheckOption> checkedAttributes;
  SkillcheckDynamic(this.checkedAttributes);
}

class SkillcheckComponent extends EyuunComponent<int> {
  List<SkillcheckOption> checkedAttributes = [];

  static const String propertyName = "skillcheck";
  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    checkedAttributes = [];
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = SkillcheckDynamicMapper.fromMap(dynamicData);
    checkedAttributes = dyn.checkedAttributes;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = SkillcheckStaticMapper.fromMap(staticData);
    checkedAttributes = stat.checkedAttributes.map((e) => SkillcheckOption(e.options, 0)).toList();
  }

  @override
  void reset() {
    checkedAttributes = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => SkillcheckDynamic(checkedAttributes).toMap();

}