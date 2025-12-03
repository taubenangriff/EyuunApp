import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/components/EyuunComponent.dart';

part 'Flux.mapper.dart';

@MappableClass()
class FluxDynamic with FluxDynamicMappable {
  int fluxSpent;
  int fluxCapacity;
  int fluxMaximum;

  FluxDynamic(this.fluxSpent, this.fluxCapacity, this.fluxMaximum);
}

class FluxComponent extends EyuunComponent<int> {
  static const String propertyName = "flux";

  /// Spent flux
  late int fluxSpent;

  /// The current flux capacity
  late int fluxCapacity;

  /// The maximum flux capacity that the character can reach
  late int fluxMaximum;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    fluxSpent = 0;
    fluxCapacity = 0;
    fluxMaximum = 0;
  }

  @override
  Map<String, dynamic> saveDynamicData() => FluxDynamic(fluxSpent, fluxCapacity, fluxMaximum).toMap();

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = FluxDynamicMapper.fromMap(dynamicData);
    fluxSpent = dyn.fluxSpent;
    fluxMaximum = dyn.fluxMaximum;
    fluxCapacity = dyn.fluxCapacity;
   }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    // TODO: implement loadStaticData
  }

}