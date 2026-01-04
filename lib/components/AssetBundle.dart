import 'package:EyuunApp/core/assetLink.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';

part 'AssetBundle.mapper.dart';


@MappableClass()
class AssetBundleStatic with AssetBundleStaticMappable {
  List<AssetLink> assets;

  AssetBundleStatic(this.assets);
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
  Map<String, dynamic> saveDynamicData() => AssetBundleStatic(assets).toMap();
}