import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:oxygen/oxygen.dart';

part 'Attribute.mapper.dart';

@MappableClass()
@reflector
class AttributeStatic with AttributeStaticMappable, ComponentReflectable {
  AssetLink? buffWhenUpgraded;

  AttributeStatic({this.buffWhenUpgraded});
}

class AttributeComponent extends EyuunComponent<int> {
  static const String propertyName = 'attribute';

  /// Buff applied to the owner each time the attribute is upgraded.
  Entity? buffWhenUpgraded;

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void reset() {
    buffWhenUpgraded = null;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    final stat = AttributeStaticMapper.fromMap(staticData);
    buffWhenUpgraded = stat.buffWhenUpgraded?.getEntity();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {}

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}
