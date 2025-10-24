import 'package:flexbackend/core/assetloader.dart';
import 'package:flexbackend/io/AssetSerializer.dart';
import 'package:get_it/get_it.dart';

import 'TextRepository.dart';
import 'WorldManager.dart';

final locator = GetIt.instance;

void setupGetIt() {
  locator.registerSingleton<WorldManager>(WorldManager());
  locator.registerSingleton<AssetLoader>(AssetLoader());
  locator.registerSingleton<TextRepository>(TextRepository());
  locator.registerLazySingleton<AssetSerializer>(() => AssetSerializer());
}