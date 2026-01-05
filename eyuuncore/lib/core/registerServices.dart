import 'package:eyuuncore/core/repository/AssetDataRepository.dart';
import 'package:eyuuncore/core/repository/StaticAssetRepository.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/core/services/assetloader.dart';
import 'package:eyuuncore/io/AssetSerializer.dart';
import 'package:get_it/get_it.dart';

import 'repository/TextRepository.dart';
import 'services/WorldManager.dart';

final locator = GetIt.instance;

void setupGetIt() {
  locator.registerSingleton<WorldManager>(WorldManager());
  locator.registerSingleton<AssetDataRepository>(AssetDataRepository());
  locator.registerSingleton<StaticAssetRepository>(StaticAssetRepository());
  locator.registerSingleton<AssetLoader>(AssetLoader());
  locator.registerSingleton<TextRepository>(TextRepository());
  locator.registerSingleton<GameObjectService>(GameObjectService());
  locator.registerSingleton<TextService>(TextService());
  locator.registerSingleton<CharacterService>(CharacterService());
  locator.registerLazySingleton<AssetSerializer>(() => AssetSerializer());

}
