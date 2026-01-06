import 'dart:convert';

import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/components/standard.dart';
import 'package:eyuuncore/components/text.dart';
import 'package:eyuuncore/core/repository/AssetDataRepository.dart';
import 'package:eyuuncore/core/repository/StaticAssetRepository.dart';
import 'package:flutter/services.dart';
import 'package:oxygen/oxygen.dart';
import 'package:uuid/uuid.dart';

import 'WorldManager.dart';
import '../registerServices.dart';

class AssetLoader {
  var worldManager = locator<WorldManager>();
  var assetRepository = locator<AssetDataRepository>();
  var staticAssetRepository = locator<StaticAssetRepository>();

  void applyStaticData(Entity entity, String typeId) {
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

  void applyDynamicData(Entity entity, Map<String, dynamic> entityMap) {
    for(var key in entityMap.keys)
    {
      if (!worldManager.isValidComponentName(key)) {
        continue;
      }
      if(!worldManager.entityHasComponent(key, entity)){
        continue;
      }

      var component = worldManager.getComponentFromEntity(key, entity);
      var submap = entityMap[key];
      component?.loadDynamicData(submap);
    }
  }

  String? getTypeIdFromAssetMap(Map<String, dynamic> assetMap) {
    return assetMap['standard']['typeId'] as String?;
  }

}
