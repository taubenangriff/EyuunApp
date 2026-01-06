import 'package:eyuuncore/io/AssetSerializer.dart';
import 'package:eyuuncore/io/GameObjectsExport.dart';
import 'package:oxygen/oxygen.dart';

import '../core/registerServices.dart';

class GameObjectsSerializer {
  final AssetSerializer _assetSerializer = locator<AssetSerializer>();

  GameObjectsSerializer();

  GameObjectsExport exportGameObjects(List<Entity> entities) {
    GameObjectsExport export = GameObjectsExport.empty();

    for(var entity in entities){
      var map = _assetSerializer.serialize(entity);
      export.gameObjects.add(map);
    }

    return export;
  }
}