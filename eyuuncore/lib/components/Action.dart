import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/BillingCycle.dart';

import '../enums/ActionTime.dart';

part 'Action.mapper.dart';

@MappableClass()
@reflector
class ActionStatic with ActionStaticMappable, ComponentReflectable {
  ActionTime actionTime;
  BillingCycle billingCycle;
  int fluxCost;
  int castingTimeMinutes;

  String? actionDescription;

  ActionStatic({
    this.actionTime = ActionTime.None,
    this.billingCycle = BillingCycle.Once,
    this.fluxCost = 0,
    this.castingTimeMinutes = 0,
    this.actionDescription,
  });
}

class ActionComponent extends EyuunComponent<int> {
  static const String propertyName = "action";

  /// The time needed to cast this
  late ActionTime actionTime;

  /// The way flux cost is deducted: Once, per round, or per hour.
  late BillingCycle billingCycle;

  /// Flux Cost
  int fluxCost = 0;

  /// If castTime is set to Minutes, this is the amount of minutes needed to cast this.
  int castingTimeMinutes = 0;

  String? actionDescription;

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
    var stat = ActionStaticMapper.fromMap(staticData);
    actionTime = stat.actionTime;
    billingCycle = stat.billingCycle;
    fluxCost = stat.fluxCost;
    castingTimeMinutes = stat.castingTimeMinutes;
    actionDescription = stat.actionDescription;
  }

  @override
  void reset() {
    actionTime = ActionTime.None;
    billingCycle = BillingCycle.Once;
    fluxCost = 0;
    castingTimeMinutes = 0;
    actionDescription = null;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
