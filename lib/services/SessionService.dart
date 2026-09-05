import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/io/SessionData.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:flutter/services.dart';

class SessionService {
  void leaveSession() {
    locator<GameObjectService>().reset();
    locator<CharacterService>().unload();
  }

  Future<void> loadTestSession() async {
    final String response = await rootBundle.loadString("data/base/char.json");
    var gameObjects = SessionDataMapper.fromJson(response);
    await _loadSession(gameObjects);
  }

  void createNewSession() {
    var character = locator<GameObjectService>().createInstance("character")!;
    locator<CharacterService>().changeCharacter(character);
    locator<WorldManager>().initiateExecution();
  }

  Future<bool> loadSession(String sessionId) async {
    // some async data loading logic
    await Future.delayed(Duration(seconds: 1));
    await loadTestSession();
    return true;
  }

  Future<List<Map<String, dynamic>>> _fetchEntityData(
      SessionData sessionData) async {
    List<Map<String, dynamic>> entityMaps = [];
    for (var objectId in sessionData.gameObjects) {
      final entityMap = await locator<DatabaseAccess>().getGameObject(
        sessionData.sessionId,
        objectId,
      );
      if (entityMap != null) {
        entityMaps.add(entityMap);
      }
    }
    return entityMaps;
  }

  /// loads a session from [gameObjects]. returns whether the loading was successful.
  Future<bool> _loadSession(SessionData sessionData) async {
    var goService = locator<GameObjectService>();
    var gameObjects = await _fetchEntityData(sessionData);
    goService.registerEntities(gameObjects);
    goService.loadEntitiesData(gameObjects);
    var character = goService.getObject(sessionData.characterId);
    if (character == null) {
      return false;
    }
    locator<CharacterService>().changeCharacter(character);
    locator<WorldManager>().execute();
    return true;
  }
}
