import 'package:EyuunApp/core/registerServices.dart';
import 'package:EyuunApp/core/services/assetloader.dart';

import '../components/feature/CombatFeature.dart';

class FeatureIds {
  static const String combatFeature = "combatFeature";
}

void registerFeatures() {
  locator.registerLazySingleton<CombatFeatureComponent>(() =>
      locator<AssetLoader>()
          .getStatic(FeatureIds.combatFeature)!
          .get<CombatFeatureComponent>()!);
}
