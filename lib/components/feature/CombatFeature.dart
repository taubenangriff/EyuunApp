import 'package:EyuunApp/core/assetLink.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

part 'CombatFeature.mapper.dart';

@MappableClass()
class CombatFeatureStatic with CombatFeatureStaticMappable {
  List<AssetLink> damageTypes;
  CombatFeatureStatic(this.damageTypes);
}

class CombatFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "combatFeature";

  List<AssetLink> damageTypes = [];

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // nothing to load here
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = CombatFeatureStaticMapper.fromMap(staticData);
    damageTypes = stat.damageTypes;
  }

  @override
  void reset() {
    damageTypes.clear();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}