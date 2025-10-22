import 'dart:math';

import 'package:flexbackend/components/BasicStats.dart';
import 'package:flexbackend/core/WorldManager.dart';
import 'package:flexbackend/core/assetloader.dart';
import 'package:oxygen/oxygen.dart';
import 'package:flexbackend/enums/dice.dart';

class BasicStatsController{

  //we will need to access other entities in the world, so every controller should know the world
  WorldManager worldManager;
  //we will need to access asset data as well, so every controller should know the assetLoader
  AssetLoader assetLoader;

  BasicStatsController(this.worldManager, this.assetLoader);

  void increaseDice(Entity entity, String statId) {
    if(!entity.has<BasicStatsComponent>()) {
      return;
    }

    var basicStats = entity.get<BasicStatsComponent>()!;
    var random = Random.secure().nextInt(Dice.values.length);
    var newDice = Dice.values[random];
    basicStats.getStatEntry(statId)?.dice = newDice;
  }
}