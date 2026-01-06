import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

part 'CombatFeature.mapper.dart';

@MappableClass()
@reflector
class CombatFeatureStatic with CombatFeatureStaticMappable, ComponentReflectable {
  List<AssetLink> damageTypes;
  List<AssetLink> healTypes;
  int damageTypesDefaultIndex;
  CombatFeatureStatic(this.damageTypes, this.healTypes, this.damageTypesDefaultIndex);
}

class CombatFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "combatFeature";

  List<AssetLink> damageTypes = [];
  List<AssetLink> healTypes = [];
  int damageTypesDefaultIndex = 0;

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
    healTypes = stat.healTypes;
    damageTypesDefaultIndex = stat.damageTypesDefaultIndex;
  }

  @override
  void reset() {
    damageTypes.clear();
    healTypes.clear();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}