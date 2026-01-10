import 'package:eyuuncore/system/collectActionsSystem.dart';

import '../system/upgradeSystem.dart';
import 'services/WorldManager.dart';

extension RegisterSystemsExtension on WorldManager {
  void registerSystems() {
    world.registerSystem(UpgradeSystem());
    world.registerSystem(CollectActionsSystem());
  }
}