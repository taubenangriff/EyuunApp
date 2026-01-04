import 'package:EyuunApp/components/feature/LevelFeature.dart';
import 'package:EyuunApp/core/registerServices.dart';
import 'package:EyuunApp/core/services/assetloader.dart';

import '../components/feature/CombatFeature.dart';
import '../components/feature/PathFeature.dart';

class FeatureIds {
  static const String combatFeature = "combat_feature";
  static const String pathFeature = "path_feature";
  static const String levelFeature = "level_feature";
}

void registerFeatures() {
  locator.registerLazySingleton<CombatFeatureComponent>(() =>
      locator<AssetLoader>()
          .getStatic(FeatureIds.combatFeature)!
          .get<CombatFeatureComponent>()!);
  locator.registerLazySingleton<PathFeatureComponent>(() =>
      locator<AssetLoader>()
          .getStatic(FeatureIds.pathFeature)!
          .get<PathFeatureComponent>()!);
  locator.registerLazySingleton<LevelFeatureComponent>(() =>
      locator<AssetLoader>()
          .getStatic(FeatureIds.levelFeature)!
          .get<LevelFeatureComponent>()!);
}
