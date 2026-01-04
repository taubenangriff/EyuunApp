import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/assetLink.dart';

part 'LevelFeature.mapper.dart';

@MappableClass()
class LevelFeatureStatic with LevelFeatureStaticMappable {
  List<AssetLink> levels;
  LevelFeatureStatic(this.levels);
}

class LevelFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "levelFeature";

  List<AssetLink> levels = [];

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
    var stat = LevelFeatureStaticMapper.fromMap(staticData);
    levels = stat.levels;
  }

  /// returns the asset corresponding to the entered level. Levels are 1-based.
  Entity? getLevelAsset(int level) {
    level = level-1;
    if(level < 0 || level >= levels.length) {
      return null;
    }
    return levels[level].getEntity();
  }

  bool isMaxLevel(int level) => level >= levels.length;

  @override
  void reset() {

  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}