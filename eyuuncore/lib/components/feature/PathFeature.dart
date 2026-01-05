import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/PathType.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';

import '../../core/assetLink.dart';

part 'PathFeature.mapper.dart';

@MappableClass()
@reflector
class PathAdditionalEntry with PathAdditionalEntryMappable {
  AssetLink additionalPathBundle;
  PathType unlockingPathType;
  PathAdditionalEntry(this.additionalPathBundle, this.unlockingPathType);
}

@MappableClass()
@reflector
class PathFeatureStatic with PathFeatureStaticMappable, ComponentReflectable {
  List<AssetLink> paths;
  List<PathAdditionalEntry> additionalPaths;
  PathFeatureStatic(this.paths, this.additionalPaths);
}

class PathFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "pathFeature";

  late List<AssetLink> paths;
  late List<PathAdditionalEntry> additionalPaths;

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
    var stat = PathFeatureStaticMapper.fromMap(staticData);
    paths = stat.paths;
    additionalPaths = stat.additionalPaths;
  }

  @override
  void reset() {
    paths = [];
    additionalPaths = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}