import '../core/components/EyuunComponent.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'Skillcheck.mapper.dart';

@MappableClass()
class SkillcheckOption with SkillcheckOptionMappable {
  List<String> options;
  SkillcheckOption(this.options);
}

@MappableClass()
class SkillcheckStatic with SkillcheckStaticMappable {
  List<SkillcheckOption> checkedAttributes;
  SkillcheckStatic(this.checkedAttributes);
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
    //nothing to load here
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = SkillcheckStaticMapper.fromMap(staticData);
    checkedAttributes = stat.checkedAttributes;
  }

  @override
  void reset() {
    checkedAttributes = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};

}