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

  Entity getEntity() => throw UnimplementedError();

  static AssetLink fromEntity(Entity e) => AssetLink(e.getTypeId());
  static AssetLink invalid() => AssetLink(noType);

  bool isValidLink() => id != noType ? locator<AssetLoader>().getStatic(id) != null : false;
}