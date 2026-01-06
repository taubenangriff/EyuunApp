import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/PathType.dart';

part 'PathStep.mapper.dart';

@MappableClass()
@reflector
class PathStepStatic with PathStepStaticMappable, ComponentReflectable {
  bool isAdditional;
  int tier;
  PathType pathType;

  PathStepStatic(this.isAdditional, this.tier, this.pathType);
}

class PathStepComponent extends EyuunComponent<int> {
  static const String propertyName = "pathStep";

  bool isAdditional = false;
  int tier = 0;
  PathType pathType = PathType.Fighter;

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
    var stat = PathStepStaticMapper.fromMap(staticData);
    isAdditional = stat.isAdditional;
    tier = stat.tier;
    pathType = stat.pathType;
  }

  @override
  void reset() {
    isAdditional = false;
    tier = 0;
    pathType = PathType.Fighter;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};


}