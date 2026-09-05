import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/repository/AssetDataRepository.dart';
import 'package:eyuuncore/core/repository/GameObjectRepository.dart';
import 'package:eyuuncore/core/repository/StaticAssetRepository.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/events/EntityCreatedEvent.dart';
import 'package:eyuuncore/events/EntityDeletedEvent.dart';
import 'package:eyuuncore/io/SessionData.dart';
import 'package:oxygen/oxygen.dart';
import 'package:uuid/uuid.dart';

import '../../io/assetloader.dart';
import '../components/standard.dart';
import '../../GetIt.dart';

class GameObjectService {
  late AssetDataRepository _assetDataRepository;
  late StaticAssetRepository _staticAssetRepository;
  late GameObjectRepository _gameObjectRepository;
  late WorldManager _worldManager;
  late AssetLoader _assetLoader;

  GameObjectService() {
    _assetDataRepository = locator<AssetDataRepository>();
    _staticAssetRepository = locator<StaticAssetRepository>();
    _gameObjectRepository = locator<GameObjectRepository>();
    _worldManager = locator<WorldManager>();
    _assetLoader = locator<AssetLoader>();
  }

  var uuid = const Uuid();

  Entity? getStatic(String typeId) {
    if (!_assetDataRepository.isValidDefinition(typeId)) {
      return null;
    }
    return _staticAssetRepository.getAssetData(typeId);
  }

  void preloadStatic(String typeId) {
    if (!_assetDataRepository.isValidDefinition(typeId)) {
      return;
    }
    var entity = _worldManager.staticWorld.createEntity();
    _staticAssetRepository.register(typeId, entity);
  }

  void loadStaticData(String typeId) {
    if (!_assetDataRepository.isValidDefinition(typeId)) {
      return;
    }
    var entity = _staticAssetRepository.getAssetData(typeId);
    if (entity == null) {
      return;
    }
    _assetLoader.applyStaticData(entity, typeId);
    if (!entity.has<StandardComponent>()) {
      return;
    }
    entity.get<StandardComponent>()?.isStatic = true;
  }

  Entity? getObject(String objectId) =>
      _gameObjectRepository.getEntity(objectId);

  Entity? createInstance(String typeId) {
    var entity = _createEntity(typeId);
    if (entity == null) {
      return null;
    }

    String id = uuid.v4();
    entity.get<StandardComponent>()?.objectId = id;

    _gameObjectRepository.registerEntity(entity);
    entity.get<StandardComponent>()?.isStatic = false;

    locator<EventBus>().fire(EntityCreatedEvent(entity));

    return entity;
  }

  Entity? _createEntity(String typeId) {
    if (!_assetDataRepository.isValidDefinition(typeId)) {
      return null;
    }

    var entity = _worldManager.world.createEntity();
    _assetLoader.applyStaticData(entity, typeId);

    if (!entity.has<StandardComponent>()) {
      return null;
    }

    return entity;
  }

  void reset() {
    for (var entity in _gameObjectRepository.getEntities()) {
      killEntity(entity);
    }
  }

  void killEntity(Entity entity) {
    var objectId = entity.getObjectId();
    entity.dispose();
    _gameObjectRepository.removeEntity(entity);
    locator<EventBus>().fire(EntityDeletedEvent(objectId));
    _worldManager.execute();
  }

  Entity? _loadEntityData(Map<String, dynamic> entityMap) {
    var objectId = _assetLoader.getObjectIdFromObjectMap(entityMap);
    if (objectId == null) {
      return null;
    }
    var entity = _gameObjectRepository.getEntity(objectId);
    if (entity == null) {
      return null;
    }

    _assetLoader.applyDynamicData(entity, entityMap);
    _gameObjectRepository.registerEntity(entity);

    entity.get<StandardComponent>()?.isStatic = false;

    return entity;
  }

  List<Entity> getObjects() => _gameObjectRepository.getEntities();

  void registerEntities(List<Map<String, dynamic>> gameObjects) {
    for (var entry in gameObjects) {
      _preloadEntity(entry);
    }
  }

  /// Loads Entity Data. In order for all objectLinks to be resolved correctly, all [SessionData] that contain data to load must be registered using [registerEntities] before any call to [loadEntitiesData] is made.
  void loadEntitiesData(List<Map<String, dynamic>> gameObjects) {
    for (var entry in gameObjects) {
      _loadEntityData(entry);
    }
  }

  void _preloadEntity(Map<String, dynamic> entityMap) {
    var typeId = _assetLoader.getTypeIdFromAssetMap(entityMap);
    if (typeId == null) {
      return;
    }
    var objectId = _assetLoader.getObjectIdFromObjectMap(entityMap);
    if (objectId == null) {
      return;
    }
    var entity = _createEntity(typeId);
    if (entity == null) {
      return;
    }
    _gameObjectRepository.preregisterEntity(entity, objectId);
  }
}
