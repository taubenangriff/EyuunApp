import 'package:flexbackend/components/EyuunComponent.dart';
import 'package:flexbackend/components/standard.dart';
import 'package:oxygen/oxygen.dart';

import '../components/BasicStats.dart';
import '../components/health.dart';


class AssetLoader {
  World world;
  AssetLoader(this.world);

  Map<String, Entity> assets = {};

  /*
    Creates a new Entity instance of typeId with objectId as it's ID.
   */
  Entity createInstance(String objectId, String typeId) {
    var entity = world.createEntity();
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
}