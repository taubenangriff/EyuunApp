import 'package:dart_mappable/dart_mappable.dart';

part 'AssetFile.mapper.dart';

@MappableClass()
class AssetFile with AssetFileMappable {
  List<String> include;
  List<dynamic> assets;

  AssetFile(this.include, this.assets);
}