import 'package:EyuunApp/components/CharacterPath.dart';
import 'package:EyuunApp/components/PathStep.dart';
import 'package:EyuunApp/components/feature/PathFeature.dart';
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

  /// picks a new path and adds it to [_characterPathComponent]. Doesn't add any pathSteps, that has to be done manually.
  void pickNewPath(String id) => UnimplementedError();

  /// returns a list of static assets of all additional paths that are available to the character at the moment.
  List<Entity> getPickableAdditionalPaths() => [];
}