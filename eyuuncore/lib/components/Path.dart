import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/PathType.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';

part 'Path.mapper.dart';

@MappableClass()
@reflector
class PathStatic with PathStaticMappable, ComponentReflectable {
  PathType pathType;
  List<AssetLink> pickableSteps;
  int complexity;

  PathStatic(this.pathType, this.pickableSteps, [ this.complexity = 1 ]);
}

class PathComponent extends EyuunComponent<int> {
  static const String propertyName = "path";

  PathType pathType = PathType.Fighter;
  late List<AssetLink> pickableSteps;
  int complexity = 0;

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
    var stat = PathStaticMapper.fromMap(staticData);
    pathType = stat.pathType;
    pickableSteps = stat.pickableSteps;
    complexity = stat.complexity;
  }

  @override
  void reset() {
    pathType = PathType.Fighter;
    pickableSteps = [];
    complexity = 0;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}