import 'package:eyuuncore/system/collectActionsSystem.dart';
import 'package:eyuuncore/system/collectUpgradesSystem.dart';

import '../system/upgradeSystem.dart';
import 'services/WorldManager.dart';

extension RegisterSystemsExtension on WorldManager {
  void registerSystems() {
    world.registerSystem(CollectWeaponUpgradesSystem());
    world.registerSystem(UpgradeSystem());
    world.registerSystem(CollectActionsSystem());
  }
}
