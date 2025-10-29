import 'dart:convert';

import 'package:flexbackend/core/components/EntityExtensions.dart';
import 'package:flexbackend/core/components/standard.dart';
import 'package:flexbackend/components/text.dart';
import 'package:flexbackend/core/repository/AssetRepository.dart';
import 'package:flutter/services.dart';
import 'package:oxygen/oxygen.dart';
import 'package:uuid/uuid.dart';

import 'WorldManager.dart';
import '../registerServices.dart';

class AssetLoader {
  var worldManager = locator<WorldManager>();
  var assetRepository = locator<AssetRepository>();

  Map<String, String> textKeys = {};

  var uuid = const Uuid();

  Map<String, Entity> staticAssets = {};

  Entity? createInstance(String typeId) {
    if (!assetRepository.isValidDefinition(typeId)) {
      return null;
    }

    String id = uuid.v4();

    var entity = worldManager.world.createEntity();
    _addComponentsToEntity(entity, typeId);
    entity.get<StandardComponent>()?.objectId = id;

    return entity;
  }

  //Get a static instance of an asset as an entity. Never change anything on that static instance though.
  Entity? getStatic(String typeId) {
    if (!assetRepository.isValidDefinition(typeId)) {
      return null;
    }
    //return cached entity if it exists
    if (!staticAssets.containsKey(typeId)) {
      return null;
    }
    return staticAssets[typeId];
  }

  //TODO add data loading as well. Right now, the only thing this does is create an empty entity with empty instances of the components defined by the asset.
  void _addComponentsToEntity(Entity entity, String typeId) {
    var asset = assetRepository.getAssetMap(typeId);
    if (asset == null) {
      throw ArgumentError(
          "typeId is not valid and doesn't point to an asset definition. This should be checked beforehand!");
    }

    for (var key in asset.keys) {
      if (!worldManager.isValidComponentName(key)) {
        continue;
      }
      worldManager.addComponentToEntity(key, entity);
      _addComponentDataToEntity(entity, key, asset);
    }
  }

  void _addComponentDataToEntity(
      Entity entity, String componentId, Map<String, dynamic> assetMap) {
    var component = worldManager.getComponentFromEntity(componentId, entity);
    var componentMap = assetMap[componentId];
    component?.loadStaticData(componentMap);
  }

  Future<void> reloadAssets() async {
    //clear entities from the static world
    for (var entity in worldManager.staticWorld.entities) {
      entity.dispose();
    }
    worldManager.staticWorld.execute(1);

    for (var asset in assetRepository.getAssetMaps()) {
      var typeId = asset['standard']['typeId'] as String?;
      if (typeId == null) {
        continue;
      }

      //load static entity
      var entity = worldManager.staticWorld.createEntity();
      _addComponentsToEntity(entity, typeId);
      staticAssets[typeId] = entity;
    }
  }

  String getTextKey(String typeId) {
    var entity = getStatic(typeId);
    return entity?.getTextKey() ?? typeId;
  }

  String getFluffKey(String typeId) {
    var entity = getStatic(typeId);
    return entity?.getFluff() ?? typeId;
  }
}
