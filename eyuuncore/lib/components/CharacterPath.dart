import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';

import '../core/assetLink.dart';

part 'CharacterPath.mapper.dart';

@MappableClass()
@reflector
class CharacterPathStatic
    with CharacterPathStaticMappable, ComponentReflectable {
  int pathCapacity;
  int additionalPathCapacity;
  CharacterPathStatic({this.pathCapacity = 0, this.additionalPathCapacity = 0});
}

@MappableClass()
class CharacterPathDynamic with CharacterPathDynamicMappable {
  List<AssetLink> chosenPaths;
  List<AssetLink> chosenPathSteps;
  CharacterPathDynamic({
    List<AssetLink>? chosenPaths,
    List<AssetLink>? chosenPathSteps,
  }) : chosenPathSteps = chosenPathSteps ?? [],
       chosenPaths = chosenPaths ?? [];
}

class CharacterPathComponent extends EyuunComponent<int> {
  static const String propertyName = "characterPath";

  /// list of [AssetLink] to all paths that this character has already chosen paths from.
  List<AssetLink> chosenPaths = [];

  /// list of [AssetLink] of all pathSteps this character has chosen.
  List<AssetLink> chosenPathSteps = [];

  /// the maximum amount of paths a character can pick.
  UpgradableInt pathCapacity = 0.upgradable;

  UpgradableInt additionalPathCapacity = 0.upgradable;

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
    var stat = CharacterPathStaticMapper.fromMap(staticData);
    pathCapacity = stat.pathCapacity.upgradable;
    additionalPathCapacity = stat.additionalPathCapacity.upgradable;
  }

  @override
  void reset() {
    pathCapacity = 0.upgradable;
    additionalPathCapacity = 0.upgradable;
    chosenPaths.clear();
    chosenPathSteps.clear();
  }

  @override
  Map<String, dynamic> saveDynamicData() => CharacterPathDynamic(
    chosenPaths: chosenPaths,
    chosenPathSteps: chosenPathSteps,
  ).toMap();
}
