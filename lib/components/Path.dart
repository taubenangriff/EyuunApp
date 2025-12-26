import 'package:EyuunApp/components/PathStep.dart';
import 'package:EyuunApp/core/assetLink.dart';
import 'package:EyuunApp/enums/PathType.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';

part 'Path.mapper.dart';

// TLDR: Do not use. We will transform this into a reusable AssetList component later which is then used by a PathFeature.

@MappableClass()
class PathStatic with PathStaticMappable {
  PathType pathType;
  List<AssetLink> pickablePaths;
  AssetLink? additionalPaths;
  int complexity;

  PathStatic(this.pathType, this.pickablePaths, [ this.additionalPaths, this.complexity = 1 ]);
}

class PathComponent extends EyuunComponent<int> {
  static const String propertyName = "path";

  PathType pathType = PathType.Fighter;
  List<AssetLink> pickablePaths = [];

  /// Links to an Asset with the [PathComponent] of which the [PathComponent.pickablePaths] are used as a list of additional Paths unlocked by speccing into this path.
  AssetLink? additionalPaths;

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
    pickablePaths = stat.pickablePaths;
    additionalPaths = stat.additionalPaths;
    complexity = stat.complexity;
  }

  @override
  void reset() {
    pathType = PathType.Fighter;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};

  int getPathLength() => pickablePaths.length;
}