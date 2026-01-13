import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';

import '../core/upgrading/UpgradableInt.dart';

part 'Flux.mapper.dart';

@MappableClass()
class FluxDynamic with FluxDynamicMappable {
  int fluxSpent;
  int fluxCapacity;
  int fluxMaximum;

  FluxDynamic({
    this.fluxSpent = 0,
    this.fluxCapacity = 0,
    this.fluxMaximum = 0,
  });
}

class FluxComponent extends EyuunComponent<int> {
  static const String propertyName = "flux";

  /// Spent flux
  late int fluxSpent;

  /// The current flux capacity
  late UpgradableInt fluxCapacity;

  /// The maximum flux capacity that the character can reach
  late UpgradableInt fluxMaximum;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    fluxSpent = 0;
    fluxCapacity = 0.upgradable;
    fluxMaximum = 0.upgradable;
  }

  @override
  Map<String, dynamic> saveDynamicData() => FluxDynamic(
    fluxSpent: fluxSpent,
    fluxCapacity: fluxCapacity.base,
    fluxMaximum: fluxMaximum.base,
  ).toMap();

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = FluxDynamicMapper.fromMap(dynamicData);
    fluxSpent = dyn.fluxSpent;
    fluxMaximum = dyn.fluxMaximum.upgradable;
    fluxCapacity = dyn.fluxCapacity.upgradable;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // TODO: implement loadStaticData
  }
}
