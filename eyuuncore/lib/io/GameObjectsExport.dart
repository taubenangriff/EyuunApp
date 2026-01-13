import 'package:dart_mappable/dart_mappable.dart';

part 'GameObjectsExport.mapper.dart';

@MappableClass()

class GameObjectsExport with GameObjectsExportMappable {
  String characterId;
  List<dynamic> gameObjects;
  GameObjectsExport(this.characterId, this.gameObjects);

  static GameObjectsExport empty() => GameObjectsExport("",[]);
}