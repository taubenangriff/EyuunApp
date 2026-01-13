import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:eyuuncore/core/reflection/Reflecting.dart';
import 'package:eyuuncore/core/reflection/reflector.dart';
import 'package:oxygen/oxygen.dart';

part 'AssetBundle.mapper.dart';

@MappableClass()
@reflector
class AssetBundleStatic with AssetBundleStaticMappable, ComponentReflectable {
  List<AssetLink> assets;

  AssetBundleStatic({List<AssetLink>? assets}) : assets = assets ?? [];
}

class AssetBundleComponent extends EyuunComponent<int> {
  static const String propertyName = "assetBundle";

  List<AssetLink> assets = [];

  List<Entity> getAssets() => assets.getAssets();

  @override
  String getName() => propertyName;

  @override
  void init([int? data]) {
    reset();
  }

  @override
  void loadDynamicData(Map<String, dynamic> dynamicData) {
    var dyn = AssetBundleStaticMapper.fromMap(dynamicData);
    assets = dyn.assets;
  }

  @override
  void loadStaticData(Map<String, dynamic> staticData) {
    var stat = AssetBundleStaticMapper.fromMap(staticData);
    assets = stat.assets;
  }

  @override
  void reset() {
    assets = [];
  }

  @override
  Map<String, dynamic> saveDynamicData() => AssetBundleStatic(assets: assets).toMap();
}
