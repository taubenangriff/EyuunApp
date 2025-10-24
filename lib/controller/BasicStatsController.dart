import 'dart:math';

import 'package:flexbackend/components/BasicStats.dart';
import 'package:flexbackend/core/services/WorldManager.dart';
import 'package:flexbackend/core/services/assetloader.dart';
import 'package:oxygen/oxygen.dart';
import 'package:flexbackend/enums/dice.dart';

import '../core/registerServices.dart';

class BasicStatsController{

  late WorldManager worldManager;
  late AssetLoader assetLoader;

  BasicStatsController(){
    worldManager = locator<WorldManager>();
    assetLoader = locator<AssetLoader>();
  }

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