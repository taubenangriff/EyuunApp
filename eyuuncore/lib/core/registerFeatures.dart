import 'package:eyuuncore/components/feature/CharacterTables.dart';
import 'package:eyuuncore/components/feature/DeathFeature.dart';
import 'package:eyuuncore/components/feature/LevelFeature.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:get_it/get_it.dart';

import '../components/feature/CombatFeature.dart';
import '../components/feature/ItemShopFeature.dart';
import '../components/feature/PathFeature.dart';

class FeatureIds {
  static const String combatFeature = "combat_feature";
  static const String pathFeature = "path_feature";
  static const String levelFeature = "level_feature";
  static const String characterTablesFeature = "character_tables_feature";
  static const String itemShopFeature = "item_shop_feature";
  static const String deathShopFeature = "death_feature";
}

extension EyuunFeaturesExtension on GetIt {
  void registerFeatures() {
    registerLazySingleton<CombatFeatureComponent>(
          () => locator<GameObjectService>()
          .getStatic(FeatureIds.combatFeature)!
          .get<CombatFeatureComponent>()!,
    );
    registerLazySingleton<PathFeatureComponent>(
          () => locator<GameObjectService>()
          .getStatic(FeatureIds.pathFeature)!
          .get<PathFeatureComponent>()!,
    );
    registerLazySingleton<LevelFeatureComponent>(
          () => locator<GameObjectService>()
          .getStatic(FeatureIds.levelFeature)!
          .get<LevelFeatureComponent>()!,
    );
    registerLazySingleton<CharacterTablesFeatureComponent>(
          () => locator<GameObjectService>()
          .getStatic(FeatureIds.characterTablesFeature)!
          .get<CharacterTablesFeatureComponent>()!,
    );
    registerLazySingleton<ItemShopFeatureComponent>(
          () => locator<GameObjectService>()
          .getStatic(FeatureIds.itemShopFeature)!
          .get<ItemShopFeatureComponent>()!,
    );
    registerLazySingleton<DeathFeatureComponent>(
          () => locator<GameObjectService>()
          .getStatic(FeatureIds.deathShopFeature)!
          .get<DeathFeatureComponent>()!,
    );
  }
}


