import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/components/AssetBundle.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:oxygen/oxygen.dart';

import '../../core/assetLink.dart';

part 'ItemShopFeature.mapper.dart';

@MappableClass()
@reflector
class ItemShopFeatureStatic with ItemShopFeatureStaticMappable, ComponentReflectable {
  AssetLink topLevelBundle;
  ItemShopFeatureStatic(this.topLevelBundle);
}

class ItemShopFeatureComponent extends EyuunComponent<int> {
  static const String propertyName = "itemShopFeature";

  /// link to the Asset with [AssetBundleComponent] that contains all the language assets.
  late AssetLink topLevelBundle;

  List<Entity> getShopItems() => topLevelBundle.getEntity()?.get<AssetBundleComponent>()?.getAssets() ?? [];

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
    var stat = ItemShopFeatureStaticMapper.fromMap(staticData);
    topLevelBundle = stat.topLevelBundle;
  }

  @override
  void reset() {
    topLevelBundle = AssetLink.invalid();
  }

  @override
  Map<String, dynamic> saveDynamicData() => <String, dynamic>{};
}