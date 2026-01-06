import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/BillingCycle.dart';

import '../enums/ActionTime.dart';

part 'Casted.mapper.dart';

@MappableClass()
@reflector
class CastedStatic with CastedStaticMappable, ComponentReflectable {
  ActionTime castTime;
  BillingCycle billingCycle;
  int fluxCost;
  int castingTimeMinutes;

  CastedStatic(this.castTime, this.billingCycle, this.fluxCost,
      [this.castingTimeMinutes = 0]);
}

class CastedComponent extends EyuunComponent<int> {
  static const String propertyName = "casted";

  /// The time needed to cast this
  late ActionTime castTime;

  /// The way flux cost is deducted: Once, per round, or per hour.
  late BillingCycle billingCycle;

  /// Flux Cost
  int fluxCost = 0;

  /// If castTime is set to Minutes, this is the amount of minutes needed to cast this.
  int castingTimeMinutes = 0;

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
    var stat = CastedStaticMapper.fromMap(staticData);
    castTime = stat.castTime;
    billingCycle = stat.billingCycle;
    fluxCost = stat.fluxCost;
    castingTimeMinutes = stat.castingTimeMinutes;
  }

  @override
  void reset() {
    castTime = ActionTime.None;
    billingCycle = BillingCycle.Once;
    fluxCost = 0;
    castingTimeMinutes = 0;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
