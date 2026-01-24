import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:oxygen/oxygen.dart';

part 'assetLink.mapper.dart';

@MappableClass()
class AssetLink with AssetLinkMappable {
  static const String noType = "noType";
  String id;

  AssetLink(this.id);

  Entity? getEntity() => locator<GameObjectService>().getStatic(id);
  Entity? createNewInstance() => locator<GameObjectService>().createInstance(id);

  static AssetLink fromEntity(Entity e) => AssetLink(e.getTypeId());
  static AssetLink invalid() => AssetLink(noType);

  bool isValidLink() => id != noType ? locator<GameObjectService>().getStatic(id) != null : false;
}

extension GetObjectLinkListObjects on Iterable<AssetLink> {
  List<Entity> getAssets() => map((AssetLink e) => e.getEntity()).where((e) => e != null).map((e) => e!).toList();
  List<Entity> createNewInstances() => map((AssetLink e) => e.createNewInstance()).where((e) => e != null).map((e) => e!).toList();
}

extension getLinkFromEntity on Entity {
  AssetLink asAssetLink() => AssetLink.fromEntity(this);
}

extension GetEntityListLinks on Iterable<Entity> {
  List<AssetLink> asAssetLinks() => map((Entity e) => AssetLink.fromEntity(e)).toList();
}