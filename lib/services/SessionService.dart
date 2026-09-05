import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/enums/CharacterState.dart';
import 'package:eyuuncore/events/SessionCreatedEvent.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/events/SessionLoadEvent.dart';
import 'package:eyuuncore/events/SessionLoadedEvent.dart';
import 'package:eyuuncore/events/SessionLeaveEvent.dart';
import 'package:eyuuncore/io/AssetSerializer.dart';
import 'package:eyuuncore/io/SessionData.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  late String sessionId;

  void leaveSession() {
    locator<EventBus>().fire(
      SessionLeaveEvent(sessionId, locator<CharacterService>().character),
    );
    locator<GameObjectService>().reset();
    locator<CharacterService>().unload();
  }

  Future<void> loadTestSession() async {
    final String response = await rootBundle.loadString("data/base/char.json");
    var gameObjects = SessionDataMapper.fromJson(response);
    await _loadSession(gameObjects);
  }

  void createNewSession() {
    sessionId = const Uuid().v4();
    var character = locator<GameObjectService>().createInstance("character")!;
    character.get<CharacterBaseComponent>()?.characterState =
        CharacterState.InCreation;
    locator<CharacterService>().changeCharacter(character);
    locator<WorldManager>().execute();

    locator<EventBus>().fire(
      SessionCreatedEvent(sessionId, character),
    );
  }

  Future<bool> loadSession(String sessionId) async {
    // some async data loading logic
    await Future.delayed(Duration(seconds: 1));

    locator<EventBus>().fire(
      SessionLoadEvent(sessionId),
    );
    var sessionData = await locator<DatabaseAccess>().getSessionData(sessionId);
    if (sessionData == null) {
      return false;
    }
    this.sessionId = sessionId;
    await _loadSession(sessionData);
    locator<EventBus>().fire(
        SessionLoadedEvent(sessionId, locator<CharacterService>().character));
    return true;
  }

  Future<List<Map<String, dynamic>>> _fetchEntityData(
      SessionData sessionData) async {
    return locator<DatabaseAccess>().getGameObjectIds(sessionData.sessionId);
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

  Future<void> persistCurrentSession() async {
    var characterId = locator<CharacterService>().character.getObjectId();
    var entities = locator<GameObjectService>().getObjects();

    var databaseAccess = locator<DatabaseAccess>();

    SessionData sessionData = SessionData(characterId, this.sessionId);
    databaseAccess.postSessionData(this.sessionId, sessionData);

    for (var entity in entities) {
      databaseAccess.postGameObject(
          this.sessionId, entity.getObjectId(), entity);
    }
  }
}
