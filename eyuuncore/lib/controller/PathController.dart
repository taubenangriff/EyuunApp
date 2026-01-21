import 'package:eyuuncore/components/CharacterPath.dart';
import 'package:eyuuncore/components/Path.dart';
import 'package:eyuuncore/components/PathStep.dart';
import 'package:eyuuncore/components/feature/PathFeature.dart';
import 'package:eyuuncore/core/assetLink.dart';
import 'package:oxygen/oxygen.dart';

import '../components/upgradable.dart';
import '../core/registerServices.dart';

class PathController {
  late CharacterPathComponent _characterPathComponent;
  late UpgradableComponent _characterUpgradableComponent;
  late PathFeatureComponent _pathFeature;

  PathController(Entity entity) {
    _pathFeature = locator<PathFeatureComponent>();
    _characterPathComponent = entity.get<CharacterPathComponent>() ?? CharacterPathComponent();
    _characterUpgradableComponent = entity.get<UpgradableComponent>() ?? UpgradableComponent();
  }

  /// returns whether the PathStep under [id] is already picked.
  ///
  /// the entity with id should have the [PathStepComponent], otherwise this method returns false.
  bool isStepPicked(String id) => true;

  /// returns whether it is possible to pick PathStep under [id].
  ///
  /// the entity with id should have the [PathStepComponent], otherwise this method returns false.
  bool canPickStep(String id) => true;

  /// picks a new pathStep and adds it to [_characterPathComponent] as well as [_characterUpgradableComponent].
  void pickStep(String id) => UnimplementedError();

  /// returns whether the path under [id] is already picked.
  bool isPathPicked(String id) => true;

  /// is it possible to pick a new path.
  bool canPickNewPath() => true;

  /// is it possible to pick a new additional path.
  bool canPickAdditional() => true;

  /// picks a new path and adds it to [_characterPathComponent]. Doesn't add any pathSteps, that has to be done manually.
  void pickNewPath(Entity path) => UnimplementedError();

  /// returns a list of static assets of all additional paths that are available to the character at the moment. Entries are assured to have [PathStepComponent].
  List<Entity> getPickableAdditionalPaths() => [];

  /// gets the current progress of the path under [id]. returns 0 if [id] does not have [PathComponent].
  int getPathProgress(String id) => 0;

  /// gets the maximum possible progress of the path under [id]. returns 0 if [id] does not have [PathComponent].
  int getPathMaximum(String id) => 0;

  List<Entity> getChosenPaths() => _characterPathComponent.chosenPaths;
  List<Entity> getChosenPathSteps() => _characterPathComponent.chosenPathSteps;
  List<Entity> getChosenAdditionalPaths() => _characterPathComponent.chosenPathSteps.where((e) => e.get<PathStepComponent>()?.isAdditional ?? false).toList();
}