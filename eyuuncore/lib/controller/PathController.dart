import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/components/CharacterPath.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/components/feature/PathFeature.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

import '../components/upgradable.dart';
import '../GetIt.dart';

class PathController {
  late CharacterPathComponent? _characterPathComponent;
  late UpgradableComponent? _characterUpgradableComponent;
  late PathFeatureComponent _pathFeature;
  late Entity _entity;

  PathController(Entity entity) {
    _entity = entity;
    _pathFeature = locator<PathFeatureComponent>();
    _characterPathComponent = entity.get<CharacterPathComponent>();
    _characterUpgradableComponent = entity.get<UpgradableComponent>();
  }

  /// returns whether the PathStep under [id] is already picked.
  ///
  /// the entity with id should have the [PathStepComponent], otherwise this method returns false.
  bool isStepPicked(Entity step) {
    if (_characterPathComponent == null) {
      return false;
    }
    return _characterPathComponent!.chosenPathSteps.any(
      (x) => x.getTypeId() == step.getTypeId(),
    );
  }

  /// returns whether it is possible to pick PathStep under [id].
  ///
  /// the entity with id should have the [PathStepComponent], otherwise this method returns false.
  bool canPickStep(Entity step) {
    if (_characterPathComponent == null) {
      return false;
    }
    if (!step.has<PathStepComponent>()) {
      return false;
    }

    var stepComponent = step.get<PathStepComponent>()!;

    if (!stepComponent.isAdditional && !canPickNewPath()) {
      return false;
    } else if (stepComponent.isAdditional && !canPickAdditional()) {
      return false;
    }

    if (_characterPathComponent!.hasPicked(step) &&
        !stepComponent.isRepeatable) {
      return false;
    }

    var path = _pathFeature.getPathOfStep(step);
    var pickedStepsCount = _characterPathComponent!.pickedStepsIn(path);
    return stepComponent.tier <= pickedStepsCount;
  }

  /// picks a new pathStep and adds it to [_characterPathComponent] as well as [_characterUpgradableComponent].
  void pickStep(Entity step) {
    if (!step.has<PathStepComponent>()) return;
    if (_characterPathComponent == null) return;
    if (_characterUpgradableComponent == null) return;

    _characterPathComponent!.chosenPathSteps.add(step);
    _characterUpgradableComponent!.applyUpgrade(step);

    var path = _pathFeature.getPathOfStep(step);

    var picked = isPathPicked(path);
    if (!picked) {
      pickNewPath(path);
    }

    locator<EventBus>().fire(
      EntityUpdatedEvent(_entity, _characterPathComponent!),
    );
    locator<EventBus>().fire(
      EntityUpdatedEvent(_entity, _characterUpgradableComponent!),
    );
  }

  /// returns whether the path under [id] is already picked.
  bool isPathPicked(Entity path) {
    if (_characterPathComponent == null) {
      return false;
    }
    return _characterPathComponent!.chosenPaths.any(
      (x) => x.getTypeId() == path.getTypeId(),
    );
  }

  /// is it possible to pick a new path.
  bool canPickNewPath() {
    if (_characterPathComponent == null) {
      return false;
    }

    return _characterPathComponent!.pathCapacity.current >
        _characterPathComponent!.chosenPathSteps
            .where((x) => !(x.get<PathStepComponent>()?.isAdditional ?? false))
            .length;
  }

  /// is it possible to pick a new additional path.
  bool canPickAdditional() {
    if (_characterPathComponent == null) {
      return false;
    }
    return _characterPathComponent!.pathCapacity.current +
            _characterPathComponent!.additionalPathCapacity.current >
        _characterPathComponent!.chosenPathSteps.length;
  }

  /// picks a new path and adds it to [_characterPathComponent]. Doesn't add any pathSteps, that has to be done manually.
  void pickNewPath(Entity path) {
    if (!path.has<PathComponent>()) return;
    if (_characterPathComponent == null) return;

    _characterPathComponent!.chosenPaths.add(path);

    locator<EventBus>().fire(
      EntityUpdatedEvent(_entity, _characterPathComponent!),
    );
  }

  /// returns a list of static assets of all additional paths that are available to the character at the moment. Entries are assured to have [PathStepComponent].
  List<Entity> getPickableAdditionalPaths() => [];

  /// gets the current progress of the path under [id]. returns 0 if [id] does not have [PathComponent].
  int getPathProgress(Entity path) {
    if (_characterPathComponent == null) return 0;
    return _characterPathComponent!.pickedStepsIn(path);
  }

  /// gets the maximum possible progress of the path under [id]. returns 0 if [id] does not have [PathComponent].
  int getPathMaximum(Entity path) =>
      path.get<PathComponent>()?.pickableSteps.length ?? 0;

  List<Entity> getChosenPaths() => _characterPathComponent?.chosenPaths ?? [];
  List<Entity> getChosenPathSteps() =>
      _characterPathComponent?.chosenPathSteps ?? [];
  List<Entity> getChosenAdditionalPaths() =>
      _characterPathComponent?.chosenPathSteps
          .where((e) => e.get<PathStepComponent>()?.isAdditional ?? false)
          .toList() ??
      [];
}
