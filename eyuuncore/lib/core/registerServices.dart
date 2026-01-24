import 'package:eyuuncore/core/repository/TextRepository.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:get_it/get_it.dart';
import '../GetIt.dart';
import 'package:eyuuncore/core/repository/AssetDataRepository.dart';
import 'package:eyuuncore/core/repository/GameObjectRepository.dart';
import 'package:eyuuncore/core/repository/StaticAssetRepository.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/LoadDataService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/io/AssetSerializer.dart';
import 'package:eyuuncore/io/GameObjectsSerializer.dart';
import 'package:eyuuncore/io/assetloader.dart';

extension EyuunCoreExtension on GetIt {
  void registerCoreServices() {
    locator.registerSingleton<WorldManager>(WorldManager());
    locator.registerSingleton<AssetDataRepository>(AssetDataRepository());
    locator.registerSingleton<StaticAssetRepository>(StaticAssetRepository());
    locator.registerSingleton<GameObjectRepository>(GameObjectRepository());
    locator.registerSingleton<AssetLoader>(AssetLoader());
    locator.registerSingleton<TextRepository>(TextRepository());
    locator.registerSingleton<GameObjectService>(GameObjectService());
    locator.registerSingleton<TextService>(TextService());
    locator.registerSingleton<CharacterService>(CharacterService());
    locator.registerSingleton<LoadDataService>(LoadDataService());
    locator.registerLazySingleton<AssetSerializer>(() => AssetSerializer());
    locator.registerLazySingleton<GameObjectsSerializer>(() => GameObjectsSerializer());
  }
}