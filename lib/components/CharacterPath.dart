import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/UpgradableInt.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';

import '../core/assetLink.dart';

part 'CharacterPath.mapper.dart';

@MappableClass()
class CharacterPathStatic with CharacterPathStaticMappable {
  int pathCapacity;
  CharacterPathStatic(this.pathCapacity);
}

@MappableClass()
class CharacterPathDynamic with CharacterPathDynamicMappable {
  List<AssetLink> chosenPaths;
  List<AssetLink> chosenPathSteps;
  CharacterPathDynamic(this.chosenPaths, this.chosenPathSteps);
}

class CharacterPathComponent extends EyuunComponent<int> {
  static const String propertyName = "characterPath";

  /// list of [AssetLink] to all paths that this character has already chosen paths from.
  List<AssetLink> chosenPaths = [];

  /// list of [AssetLink] of all pathSteps this character has chosen.
  List<AssetLink> chosenPathSteps = [];

  /// the maximum amount of paths a character can pick.
  UpgradableInt pathCapacity = 0.upgradable;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = CharacterPathDynamicMapper.fromMap(dynamicData);
    chosenPaths = dyn.chosenPaths;
    chosenPathSteps = dyn.chosenPathSteps;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var dyn = CharacterPathStaticMapper.fromMap(staticData);
    pathCapacity = dyn.pathCapacity.upgradable;
  }

  @override
  void reset() {
    pathCapacity = 0.upgradable;
    chosenPaths.clear();
    chosenPathSteps.clear();
  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterPathDynamic(chosenPaths, chosenPathSteps).toMap();
}