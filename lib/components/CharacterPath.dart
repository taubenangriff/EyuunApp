import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/UpgradableInt.dart';
import 'package:flexbackend/core/components/EyuunComponent.dart';

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
  CharacterPathDynamic(this.chosenPaths);
}

class CharacterPathComponent extends EyuunComponent<int> {
  static const String propertyName = "characterPath";

  List<AssetLink> chosenPaths = [];
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
  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterPathDynamic(chosenPaths).toMap();
}