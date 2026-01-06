import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/repository/AssetDataRepository.dart';
import 'package:eyuuncore/core/repository/GameObjectRepository.dart';
import 'package:eyuuncore/core/repository/StaticAssetRepository.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
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

  Entity? getObject(String objectId) => _gameObjectRepository.getEntity(objectId);

  Entity? createInstance(String typeId) {
    if(!_assetDataRepository.isValidDefinition(typeId)){
      return null;
    }

    var entity = _worldManager.world.createEntity();
    _assetLoader.applyStaticData(entity, typeId);

    String id = uuid.v4();
    entity.get<StandardComponent>()?.objectId = id;

    _gameObjectRepository.registerEntity(entity);

    return entity;
  }

  Entity? loadEntity(Map<String, dynamic> entityMap) {
    var typeId = _assetLoader.getTypeIdFromAssetMap(entityMap);
    if (typeId == null) {
      return null;
    }

    var entity = _worldManager.world.createEntity();
    _assetLoader.applyStaticData(entity, typeId);
    _assetLoader.applyDynamicData(entity, entityMap);

    _gameObjectRepository.registerEntity(entity);

    return entity;
  }
}