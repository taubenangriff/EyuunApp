import 'dart:convert';

import 'package:flexbackend/components/EyuunComponent.dart';
import 'package:flexbackend/components/standard.dart';
import 'package:flutter/services.dart';
import 'package:oxygen/oxygen.dart';

import '../components/BasicStats.dart';
import '../components/health.dart';
import 'WorldManager.dart';

String assetFile = "data/base/asset/assets.json";

class AssetLoader {
  WorldManager worldManager;
  AssetLoader(this.worldManager);

  Map<String, Map<String, dynamic>> assets = {};

  /*
    Creates a new Entity instance of typeId with objectId as it's ID.
   */
  Entity createTestEntity(String objectId, String typeId) {
    var entity = worldManager.world.createEntity();
    entity
        ..add<StandardComponent, String>(objectId)
        ..add<HealthComponent, int>()
        ..add<BasicStatsComponent, int>();

    var standard = entity.get<StandardComponent>();
    standard?.typeId = typeId;
    standard?.comment = "NoComment";
    standard?.internalName = "TestAsset";

    var health = entity.get<HealthComponent>();
    health?.maxHitpoints = 30;
    health?.hitpoints = health!.maxHitpoints;
    health?.maxDeathThrows = 3;
    health?.maxShield = 8;

    var baseStats = entity.get<BasicStatsComponent>();
    baseStats?.statValues['baseSkill_Courage'] = 5;
    baseStats?.statValues['baseSkill_Intelligence'] = 7;

    return entity;
  }

  //TODO add data loading as well. Right now, the only thing this does is create an empty entity with empty instances of the components defined by the asset.
  Entity? createInstance(String typeId)
  {
    if(!assets.containsKey(typeId)) {
      return null;
    }
    var asset = assets[typeId];
    if(asset == null) {
      return null;
    }
    var entity = worldManager.world.createEntity();

    for (var key in asset.keys) {
      if(!worldManager.isValidComponentName(key)){
        continue;
      }
      worldManager.addComponentToEntity(key, entity);
    }

    return entity;
  }

  Future<void> reloadAssets()
  async {
    assets.clear();
    final String response = await rootBundle.loadString(assetFile);
    Map<String, dynamic> data = await json.decode(response);

    var assetArray = data['assets'];
    for(var asset in assetArray) {
      //we want var typeId = asset['standard']['typeId'] but in safe.
      var standard = asset['standard'] as Map<String, dynamic>?;
      if(standard == null) {
        continue;
      }
      var typeId = standard['typeId'] as String?;
      if(typeId == null) {
        continue;
      }
      assets[typeId] = asset as Map<String, dynamic>;
    }
  }
}