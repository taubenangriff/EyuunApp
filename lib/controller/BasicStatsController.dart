import 'package:flexbackend/components/BasicStats.dart';
import 'package:flexbackend/io/WorldManager.dart';
import 'package:flexbackend/io/assetloader.dart';
import 'package:oxygen/oxygen.dart';

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
    basicStats.getStatEntry(statId)?.dice += 1;
    basicStats.getStatEntry(statId)?.dice %= 15;
  }
}