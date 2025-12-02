import 'package:dart_mappable/dart_mappable.dart';

part 'assetLink.mapper.dart';

@MappableClass()
class AssetLink with AssetLinkMappable {
  String id;

  AssetLink(this.id);
}