import 'package:eyuuncore/components/Action.dart';
import 'package:eyuuncore/components/ActionUser.dart';
import 'package:eyuuncore/components/Combat.dart';
import 'package:eyuuncore/components/SkillLearner.dart';
import 'package:eyuuncore/components/Weapon.dart';
import 'package:eyuuncore/components/inventory.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:oxygen/oxygen.dart';

import '../GetIt.dart';
import '../core/services/WorldManager.dart';

class CollectWeaponUpgradesSystem extends System {
  WorldManager worldManager = locator<WorldManager>();

  late Query weaponQuery;

  @override
  void init() {
    weaponQuery = createQuery([
      Has<WeaponComponent>(),
      Has<UpgradableComponent>(),
    ]);
  }

  @override
  /// reapplies the effects of all entities with an UpgradableComponent.
  void execute(double delta) {
    for (var entity in weaponQuery.entities) {
      entity.get<UpgradableComponent>()?.clearTransientUpgrades();
      var weaponType = entity.get<WeaponComponent>()?.weaponType;
      if (weaponType != null) {
        entity.get<UpgradableComponent>()?.applyUpgrade(weaponType);
      }
    }
  }
}
