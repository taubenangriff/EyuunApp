import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';

import '../core/UpgradableInt.dart';
import '../core/reflection/Reflecting.dart';
import '../core/reflection/reflector.dart';

part 'Boon.mapper.dart';

@MappableClass()
@reflector
class BoonStatic with BoonStaticMappable, ComponentReflectable {
  int maxBoon;

  BoonStatic(this.maxBoon);
}

@MappableClass()
class BoonDynamic with BoonDynamicMappable {
  int currentBoon;
  int boonRegeneration;
  int boonSpentSinceLastRest;

  BoonDynamic(this.currentBoon, this.boonRegeneration, this.boonSpentSinceLastRest);
}

class BoonComponent extends EyuunComponent<int> {
  static const String propertyName = "boon";

  late int currentBoon;
  late int boonSpentSinceLastRest;
  late UpgradableInt boonRegeneration;

  @override
  String getName() => propertyName;


  @override
  void init([int? data]) {
    reset();
  }

  @override
  Map<String, dynamic> saveDynamicData() => BoonDynamic(currentBoon, boonRegeneration.base, boonSpentSinceLastRest).toMap();

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = BoonDynamicMapper.fromMap(dynamicData);
    currentBoon = dyn.currentBoon;
    boonRegeneration = dyn.boonRegeneration.upgradable;
    boonSpentSinceLastRest = dyn.boonSpentSinceLastRest;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // nothing to load here
  }

  @override
  void reset() {
    boonSpentSinceLastRest = 0;
    currentBoon = 0;
    boonRegeneration = 0.upgradable;
  }


}