import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:oxygen/oxygen.dart';

import '../core/components/EyuunComponent.dart';

part 'CraftMethod.mapper.dart';

@MappableClass()
@reflector
class CraftMethodStatic with CraftMethodStaticMappable, ComponentReflectable {
  AssetLink appliedEffect;
  int increaseSuccessThreshold;

  CraftMethodStatic({appliedEffect, this.increaseSuccessThreshold = 0})
    : appliedEffect = appliedEffect ?? [];
}

class CraftMethodComponent extends EyuunComponent<int> {
  static const String propertyName = "craftMethod";

  /// [AssetLink] to the effect that is applied to a weapon when it is crafted using this craft method.
  late Entity? appliedEffect;

  /// How much the skillcheck threshold is increased by this craft method
  int increaseSuccessThreshold = 0;

  /// Whether this craftMethod applies an effect on construction.
  bool appliesEffect() => appliedEffect != null;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    // nothing to load here.
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = CraftMethodStaticMapper.fromMap(staticData);
    appliedEffect = stat.appliedEffect.getEntity();
    increaseSuccessThreshold = stat.increaseSuccessThreshold;
  }

  @override
  void reset() {
    increaseSuccessThreshold = 0;
    appliedEffect = null;
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
