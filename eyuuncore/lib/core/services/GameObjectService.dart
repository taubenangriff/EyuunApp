import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/repository/AssetDataRepository.dart';
import 'package:eyuuncore/core/repository/GameObjectRepository.dart';
import 'package:eyuuncore/core/repository/StaticAssetRepository.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/io/GameObjectsExport.dart';
import 'package:oxygen/oxygen.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v8.dart';

import '../components/standard.dart';
import '../registerServices.dart';
import 'assetloader.dart';

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
    if(!_assetDataRepository.isValidDefinition(typeId)){
      return null;
    }
    return _staticAssetRepository.getAssetData(typeId);
  }

  void registerStatic(String typeId) {
    if(!_assetDataRepository.isValidDefinition(typeId)){
      return;
    }
    var entity = _worldManager.staticWorld.createEntity();
    _assetLoader.applyStaticData(entity, typeId);
    if(!entity.has<StandardComponent>()){
      return;
    }
    entity.get<StandardComponent>()?.isStatic = true;

    _staticAssetRepository.register(typeId, entity);
  }

  Entity? getObject(String objectId) => _gameObjectRepository.getEntity(objectId);

  Entity? createInstance(String typeId) {
    var entity = _createEntity(typeId);
    if(entity == null){
      return null;
    }

    String id = uuid.v4();
    entity.get<StandardComponent>()?.objectId = id;

    _gameObjectRepository.registerEntity(entity);
    entity.get<StandardComponent>()?.isStatic = false;

    return entity;
  }

  Entity? _createEntity(String typeId) {
    if(!_assetDataRepository.isValidDefinition(typeId)){
      return null;
    }

    var entity = _worldManager.world.createEntity();
    _assetLoader.applyStaticData(entity, typeId);

    if(!entity.has<StandardComponent>()){
      return null;
    }

    return entity;
  }

  Entity? loadEntity(Map<String, dynamic> entityMap) {
    var typeId = _assetLoader.getTypeIdFromAssetMap(entityMap);
    if (typeId == null) {
      return null;
    }
    var entity = _createEntity(typeId);
    if(entity == null){
      return null;
    }

    _assetLoader.applyDynamicData(entity, entityMap);
    _gameObjectRepository.registerEntity(entity);

    entity.get<StandardComponent>()?.isStatic = false;

    return entity;
  }

  List<Entity> getObjects() => _gameObjectRepository.getEntities();

  void loadEntities(GameObjectsExport export){
    for(var entry in export.gameObjects){
      if(entry is Map<String, dynamic>){
        loadEntity(entry);
      }
    }
  }
}