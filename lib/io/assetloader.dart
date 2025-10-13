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
  Map<String, String> textKeys = {};

  /*
    Creates our test character that isn't loaded from anywhere.
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
    baseStats?.statValues.add(BasicStatEntry.from('baseSkill_Courage', 5));
    baseStats?.statValues.add(BasicStatEntry.from('baseSkill_Intelligence', 9));

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
      var typeId = asset['standard']['typeId'] as String?;
      if(typeId == null) {
        continue;
      }

      //grab the text as static data
      var text = asset['text']['textKey'] as String?;
      if(text is String){
        textKeys[typeId] = text;
      }

      //register asset
      assets[typeId] = asset as Map<String, dynamic>;
    }
  }

  String getTextKey(String typeId){
    if(textKeys.containsKey(typeId)){
      return textKeys[typeId] as String;
    }
    return typeId;
  }
}