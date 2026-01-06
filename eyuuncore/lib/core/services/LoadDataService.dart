import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/assetloader.dart';

import '../registerServices.dart';
import '../repository/AssetDataRepository.dart';
import 'WorldManager.dart';

class LoadDataService {
  final _worldManager = locator<WorldManager>();
  final _assetDataRepository = locator<AssetDataRepository>();
  final _assetLoader = locator<AssetLoader>();
  final _gameObjectService = locator<GameObjectService>();

  Future<void> reloadAssets() async {
    //clear entities from the static world
    for (var entity in _worldManager.staticWorld.entities) {
      entity.dispose();
    }
    _worldManager.staticWorld.execute(1);

    for (var asset in _assetDataRepository.getAssetMaps()) {
      var typeId = _assetLoader.getTypeIdFromAssetMap(asset);
      if (typeId == null) {
        continue;
      }
      _gameObjectService.registerStatic(typeId);
    }
  }
}