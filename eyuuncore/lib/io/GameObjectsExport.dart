import 'package:dart_mappable/dart_mappable.dart';

part 'GameObjectsExport.mapper.dart';

@MappableClass()

class GameObjectsExport with GameObjectsExportMappable {
  List<dynamic> gameObjects;
  GameObjectsExport(this.gameObjects);

  static GameObjectsExport empty() => GameObjectsExport([]);
}