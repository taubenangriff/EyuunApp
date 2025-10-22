import '../system/upgradeSystem.dart';
import '../core/WorldManager.dart';

extension RegisterSystemsExtension on WorldManager {
  void registerSystems() {
    world.registerSystem(UpgradeSystem());
  }
}