import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/components/feature/LevelFeature.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/core/services/assetloader.dart';

import '../components/feature/CombatFeature.dart';
import '../components/feature/PathFeature.dart';

class FeatureIds {
  static const String combatFeature = "combat_feature";
  static const String pathFeature = "path_feature";
  static const String levelFeature = "level_feature";
  static const String characterTablesFeature = "character_tables_feature";
}

void registerFeatures() {
  locator.registerLazySingleton<CombatFeatureComponent>(() =>
      locator<GameObjectService>()
          .getStatic(FeatureIds.combatFeature)!
          .get<CombatFeatureComponent>()!);
  locator.registerLazySingleton<PathFeatureComponent>(() =>
      locator<GameObjectService>()
          .getStatic(FeatureIds.pathFeature)!
          .get<PathFeatureComponent>()!);
  locator.registerLazySingleton<LevelFeatureComponent>(() =>
      locator<GameObjectService>()
          .getStatic(FeatureIds.levelFeature)!
          .get<LevelFeatureComponent>()!);
  locator.registerLazySingleton<CharacterTablesFeatureComponent>(() =>
      locator<GameObjectService>()
          .getStatic(FeatureIds.characterTablesFeature)!
          .get<CharacterTablesFeatureComponent>()!);
}
