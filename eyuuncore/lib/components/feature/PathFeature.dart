import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/PathType.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/assetLink.dart';

part 'PathFeature.mapper.dart';

class PathAdditionalEntry {
  Entity additionalPathBundle;
  PathType unlockingPathType;
  PathAdditionalEntry(this.additionalPathBundle, this.unlockingPathType);

  static PathAdditionalEntry? fromStatic(PathAdditionalEntryStatic e) {
    var entity = e.additionalPathBundle.getEntity();
    if (entity == null) {
      return null;
    }
    return PathAdditionalEntry(entity, e.unlockingPathType);
  }
}

@MappableClass()
@reflector
class PathAdditionalEntryStatic with PathAdditionalEntryStaticMappable {
  AssetLink additionalPathBundle;
  PathType unlockingPathType;
  PathAdditionalEntryStatic({
    AssetLink? additionalPathBundle,
    this.unlockingPathType = PathType.Fighter,
  }) : additionalPathBundle = additionalPathBundle ?? AssetLink.invalid();

  static PathAdditionalEntryStatic from(PathAdditionalEntry e) {
    return PathAdditionalEntryStatic(
      additionalPathBundle: e.additionalPathBundle.asAssetLink(),
      unlockingPathType: e.unlockingPathType,
    );
  }
}

@MappableClass()
@reflector
class PathFeatureStatic with PathFeatureStaticMappable, ComponentReflectable {
  List<AssetLink> paths;
  List<PathAdditionalEntryStatic> additionalPaths;
  PathFeatureStatic(this.paths, this.additionalPaths);
}

class PathFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "pathFeature";

  late List<Entity> paths;
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
    paths = stat.paths.getAssets();
    additionalPaths = stat.additionalPaths
        .map((e) => PathAdditionalEntry.fromStatic(e))
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
  }

  @override
  void reset() {
    paths = [];
    additionalPaths = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
