import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:eyuuncore/enums/AttributeImpactType.dart';
import 'package:eyuuncore/io/EnumMapper.dart';
import 'package:oxygen/oxygen.dart';

part 'Attribute.mapper.dart';

@MappableClass(includeCustomMappers: [AttributeImpactTypeDoubleMapper()])
@reflector
class AttributeStatic with AttributeStaticMappable, ComponentReflectable {
  AssetLink? buffWhenUpgraded;

  Map<AttributeImpactType, double> impactMultipliers = {};

  AttributeStatic({
    this.buffWhenUpgraded,
    Map<AttributeImpactType, double>? impactMultipliers,
  }) {
    if (impactMultipliers != null) {
      this.impactMultipliers = impactMultipliers;
    }
  }
}

class AttributeComponent extends EyuunComponent<int> {
  static const String propertyName = 'attribute';

  /// Buff applied to the owner each time the attribute is upgraded.
  Entity? buffWhenUpgraded;
  late Map<AttributeImpactType, double> impactMultipliers;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    buffWhenUpgraded = null;
    impactMultipliers = {};
  }

  double getImpact(AttributeImpactType type) {
    return impactMultipliers[type] ?? 0.0;
  }

  bool hasImpact(AttributeImpactType type) {
    return impactMultipliers.containsKey(type);
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    final stat = AttributeStaticMapper.fromMap(staticData);
    buffWhenUpgraded = stat.buffWhenUpgraded?.getEntity();
    impactMultipliers = stat.impactMultipliers;
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {}

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
