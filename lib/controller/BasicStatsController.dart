import 'dart:math';

import 'package:EyuunApp/components/Attributes.dart';
import 'package:EyuunApp/core/services/WorldManager.dart';
import 'package:EyuunApp/core/services/assetloader.dart';
import 'package:oxygen/oxygen.dart';
import 'package:EyuunApp/enums/dice.dart';

import '../core/registerServices.dart';

class BasicStatsController{

  late WorldManager worldManager;
  late AssetLoader assetLoader;

  BasicStatsController(){
    worldManager = locator<WorldManager>();
    assetLoader = locator<AssetLoader>();
  }

  void increaseDice(Entity entity, String statId) {
    if(!entity.has<AttributesComponent>()) {
      return;
    }

    var basicStats = entity.get<AttributesComponent>()!;
    var random = Random.secure().nextInt(Dice.values.length);
    var newDice = Dice.values[random];
    basicStats.getStatEntry(statId)?.dice = newDice;
  }
}