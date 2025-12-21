import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/components/EntityExtensions.dart';
import 'package:flexbackend/core/registerServices.dart';
import 'package:flexbackend/core/services/assetloader.dart';
import 'package:oxygen/oxygen.dart';

part 'assetLink.mapper.dart';

@MappableClass()
class AssetLink with AssetLinkMappable {
  String id;

  AssetLink(this.id);

  Entity getEntity() => throw UnimplementedError();

  static AssetLink fromEntity(Entity e) => AssetLink(e.getTypeId());

  bool isValidLink() => locator<AssetLoader>().getStatic(id) != null;
}