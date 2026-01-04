import 'package:eyuuncore/core/repository/AssetRepository.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/core/services/assetloader.dart';
import 'package:eyuuncore/io/AssetSerializer.dart';
import 'package:get_it/get_it.dart';

import 'repository/TextRepository.dart';
import 'services/WorldManager.dart';

final locator = GetIt.instance;

void setupGetIt() {
  locator.registerSingleton<WorldManager>(WorldManager());
  locator.registerSingleton<AssetRepository>(AssetRepository());
  locator.registerSingleton<AssetLoader>(AssetLoader());
  locator.registerSingleton<TextRepository>(TextRepository());
  locator.registerSingleton<TextService>(TextService());
  locator.registerSingleton<CharacterService>(CharacterService());
  locator.registerLazySingleton<AssetSerializer>(() => AssetSerializer());
}
