import 'dart:convert';

import 'package:flexbackend/components/text.dart';
import 'package:flutter/services.dart';
import 'package:oxygen/oxygen.dart';
import 'WorldManager.dart';

String assetFile = "data/base/asset/assets.json";

class AssetLoader {
  var worldManager = WorldManager.instance;

  static AssetLoader instance = AssetLoader();

  Map<String, Map<String, dynamic>> assets = {};
  Map<String, String> textKeys = {};

  Map<String, Entity> staticAssets = {};

  Entity? createInstance(String typeId) {
    if(!isValidDefinition(typeId)) {
      return null;
    }
    var entity = worldManager.world.createEntity();
    _addComponentsToEntity(entity, typeId);
    return entity;
  }

  //Get a static instance of an asset as an entity. Never change anything on that static instance though.
  Entity? getStatic(String typeId) {
    if(!isValidDefinition(typeId)) {
      return null;
    }
    //return cached entity if it exists
    if(!staticAssets.containsKey(typeId)){
      return null;
    }
    return staticAssets[typeId];
  }

  bool isValidDefinition(String typeId) {
    if(!assets.containsKey(typeId)) {
      return false;
    }
    return true;
  }


  //TODO add data loading as well. Right now, the only thing this does is create an empty entity with empty instances of the components defined by the asset.
  void _addComponentsToEntity(Entity entity, String typeId) {
    var asset = assets[typeId];
    if(asset == null) {
      throw ArgumentError("typeId is not valid and doesn't point to an asset definition. This should be checked beforehand!");
    }

    for (var key in asset.keys) {
      if(!worldManager.isValidComponentName(key)){
        continue;
      }
      worldManager.addComponentToEntity(key, entity);
      _addComponentDataToEntity(entity, key, asset);
    }
  }

  void _addComponentDataToEntity(Entity entity, String componentId, Map<String, dynamic> assetMap)
  {
    var component = worldManager.getComponentFromEntity(componentId, entity);
    var componentMap = assetMap[componentId];
    component?.loadStaticData(componentMap);
  }

  Future<void> reloadAssets() async {
    assets.clear();

    //clear entities from the static world
    for (var entity in worldManager.staticWorld.entities){
      entity.dispose();
    }
    worldManager.staticWorld.execute(1);

    final String response = await rootBundle.loadString(assetFile);
    Map<String, dynamic> data = await json.decode(response);

    var assetArray = data['assets'];
    for(var asset in assetArray) {
      //we want var typeId = asset['standard']['typeId'] but in safe.
      var typeId = asset['standard']['typeId'] as String?;
      if(typeId == null) {
        continue;
      }
      //register asset
      assets[typeId] = asset as Map<String, dynamic>;

      //load static entity and register that as well.
      var entity = worldManager.staticWorld.createEntity();
      _addComponentsToEntity(entity, typeId);
      staticAssets[typeId] = entity;
    }
  }

  String getTextKey(String typeId) {
    var entity = getStatic(typeId);

    if(entity?.has<TextComponent>() ?? false)
    {
      var textOverride = entity?.get<TextComponent>()?.textOverride;
      if(textOverride != null){
        return textOverride;
      }
    }

    return typeId;
  }
}