import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EntityExtensions.dart';
import 'package:EyuunApp/core/registerServices.dart';
import 'package:EyuunApp/core/services/assetloader.dart';
import 'package:oxygen/oxygen.dart';

part 'assetLink.mapper.dart';

@MappableClass()
class AssetLink with AssetLinkMappable {
  static const String noType = "noType";
  String id;

  AssetLink(this.id);

  Entity? getEntity() => locator<AssetLoader>().getStatic(id);
  Entity? getNewEntityInstance() => locator<AssetLoader>().createInstance(id);

  static AssetLink fromEntity(Entity e) => AssetLink(e.getTypeId());
  static AssetLink invalid() => AssetLink(noType);

  bool isValidLink() => id != noType ? locator<AssetLoader>().getStatic(id) != null : false;
}

extension GetObjectLinkListObjects on Iterable<AssetLink> {
  List<Entity> getAssets() => map((AssetLink e) => e.getEntity()).where((e) => e != null).map((e) => e!).toList();
  List<Entity> getNewAssetInstances() => map((AssetLink e) => e.getNewEntityInstance()).where((e) => e != null).map((e) => e!).toList();
}