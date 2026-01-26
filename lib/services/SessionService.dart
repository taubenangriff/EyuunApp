import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/io/GameObjectsExport.dart';
import 'package:flutter/services.dart';

class SessionService {
  void leaveSession() {
    locator<GameObjectService>().reset();
    locator<CharacterService>().unload();
  }

  Future<void> loadTestSession() async {
    final String response = await rootBundle.loadString("data/base/char.json");
    var gameObjects = GameObjectsExportMapper.fromJson(response);
    _loadSession(gameObjects);
  }

  void createNewSession() {
    var character = locator<GameObjectService>().createInstance("character")!;
    locator<CharacterService>().changeCharacter(character);
    locator<WorldManager>().execute();
  }

  Future<bool> loadSession(String sessionId) async {
    // some async data loading logic
    await Future.delayed(Duration(seconds: 1));
    await loadTestSession();
    return true;
  }

  /// loads a session from [gameObjects]. returns whether the loading was successful.
  bool _loadSession(GameObjectsExport gameObjects) {
    var goService = locator<GameObjectService>();
    goService.registerEntities(gameObjects);
    goService.loadEntitiesData(gameObjects);
    var character = goService.getObject(gameObjects.characterId);
    if(character == null){
      return false;
    }
    locator<CharacterService>().changeCharacter(character);
    locator<WorldManager>().execute();
    return true;
  }
}