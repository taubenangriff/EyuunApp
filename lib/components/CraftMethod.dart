import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/assetLink.dart';

import '../core/components/EyuunComponent.dart';

part 'CraftMethod.mapper.dart';

@MappableClass()
class CraftMethodStatic with CraftMethodStaticMappable {
  String appliedEffect;
  int increaseSuccessThreshold;

  CraftMethodStatic(this.appliedEffect, this.increaseSuccessThreshold);
}

class CraftMethodComponent extends EyuunComponent<int> {
  static const String propertyName = "craftMethod";

  /// [AssetLink] to the effect that is applied to a weapon when it is crafted using this craft method.
  late AssetLink appliedEffect;

  /// How much the skillcheck threshold is increased by this craft method
  int increaseSuccessThreshold = 0;

  /// Whether this craftMethod applies an effect on construction.
  bool appliesEffect() => appliedEffect.isValidLink() ?? false;

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
    appliedEffect = AssetLink(stat.appliedEffect);
    increaseSuccessThreshold = stat.increaseSuccessThreshold;
  }

  @override
  void reset() {
    increaseSuccessThreshold = 0;
    appliedEffect = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}