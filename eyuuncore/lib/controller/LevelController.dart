import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/feature/LevelFeature.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

class LevelController {
  Entity levelEntity;
  late CharacterBaseComponent _characterBase;
  late UpgradableComponent _upgradable;
  late LevelFeatureComponent _levelFeature;

  LevelController(this.levelEntity) {
    if (!levelEntity.has<CharacterBaseComponent>()) {
      throw Exception('Level entity does not have a CharacterBaseComponent');
    }
    if (!levelEntity.has<UpgradableComponent>()) {
      throw Exception('Level entity does not have an UpgradableComponent');
    }
    _characterBase = levelEntity.get<CharacterBaseComponent>()!;
    _upgradable = levelEntity.get<UpgradableComponent>()!;
    _levelFeature = locator<LevelFeatureComponent>();
  }

  Entity? getNextLevel() {
    return _levelFeature.getLevelAsset(_characterBase.level + 1);
  }

  bool isMaxLevel() {
    return _levelFeature.isMaxLevel(_characterBase.level);
  }

  bool canUpgrade() {
    return !_levelFeature.isMaxLevel(_characterBase.level);
  }

  void levelup() {
    if (!canUpgrade()) {
      throw Exception('Cannot level up, already at max level');
    }
    var nextLevel = _levelFeature.getLevelAsset(_characterBase.level + 1);
    if (nextLevel == null) return;

    _upgradable.applyUpgrade(nextLevel);
    _characterBase.level += 1;

    locator<EventBus>().fire(EntityUpdatedEvent(levelEntity, _characterBase));
    locator<EventBus>().fire(EntityUpdatedEvent(levelEntity, _upgradable));
    locator<WorldManager>().execute();
  }
}
