import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';
import '../../core/assetLink.dart';
import '../../core/reflection/Reflecting.dart';
import '../../core/reflection/reflector.dart';

part 'DeathFeature.mapper.dart';

@MappableClass()
@reflector
class DeathFeatureStatic with DeathFeatureStaticMappable, ComponentReflectable {
  int baseThreshold;
  int increaseThresholdPerFail;
  int minimumHealthToLive;
  AssetLink deathSkillcheck;

  DeathFeatureStatic(
    this.baseThreshold,
    this.increaseThresholdPerFail,
    this.minimumHealthToLive,
    AssetLink? deathSkillcheck,
  ) : deathSkillcheck = deathSkillcheck ?? AssetLink.invalid();
}

class DeathFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "deathFeature";

  late int baseThreshold;
  late int increaseThresholdPerFail;
  late int minimumHealthToLive;
  late Entity? deathSkillcheck;

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
    var stat = DeathFeatureStaticMapper.fromMap(staticData);
    baseThreshold = stat.baseThreshold;
    increaseThresholdPerFail = stat.increaseThresholdPerFail;
    minimumHealthToLive = stat.minimumHealthToLive;
    deathSkillcheck = stat.deathSkillcheck.getEntity();
  }

  @override
  void reset() {
    baseThreshold = 0;
    increaseThresholdPerFail = 0;
    minimumHealthToLive = 0;
    deathSkillcheck = null;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
