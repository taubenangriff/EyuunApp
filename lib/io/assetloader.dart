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
    baseStats?.statValues[BasicStat.courage] = 5;
    baseStats?.statValues[BasicStat.intelligence] = 7;
    baseStats?.statValues[BasicStat.intuition] = 14;
    baseStats?.statValues[BasicStat.charisma] = 9;
    baseStats?.statValues[BasicStat.dexterity] = 10;
    baseStats?.statValues[BasicStat.agility] = 12;
    baseStats?.statValues[BasicStat.constitution] = 10;
    baseStats?.statValues[BasicStat.strength] = 13;

    return entity;
  }

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