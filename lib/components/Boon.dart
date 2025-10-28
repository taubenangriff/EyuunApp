import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/components/EyuunComponent.dart';

import '../core/UpgradableInt.dart';

part 'Boon.mapper.dart';

@MappableClass()
class BoonStatic with BoonStaticMappable {
  int maxBoon;

  BoonStatic(this.maxBoon);
}

@MappableClass()
class BoonDynamic with BoonDynamicMappable {
  int currentBoon;
  int boonRegeneration;

  BoonDynamic(this.currentBoon, this.boonRegeneration);
}

class BoonComponent extends EyuunComponent<int> {
  static const String propertyName = "boon";

  late UpgradableInt maxBoon;
  late int currentBoon;
  late int boonRegeneration;

  @override
  String getName() => propertyName;


  @override
  void init([int? data]) {
    reset();
  }

  @override
  Map<String, dynamic> saveDynamicData() => BoonDynamic(currentBoon, boonRegeneration).toMap();

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = BoonDynamicMapper.fromMap(dynamicData);
    currentBoon = dyn.currentBoon;
    boonRegeneration = dyn.boonRegeneration;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = BoonStaticMapper.fromMap(staticData);
    maxBoon = stat.maxBoon.upgradable;
  }

  @override
  void reset() {
    maxBoon = 0.upgradable;
    currentBoon = 0;
    boonRegeneration = 0;
  }


}