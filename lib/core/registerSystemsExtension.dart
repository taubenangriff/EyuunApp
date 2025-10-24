import '../system/upgradeSystem.dart';
import 'WorldManager.dart';

extension RegisterSystemsExtension on WorldManager {
  void registerSystems() {
    world.registerSystem(UpgradeSystem());
  }
}