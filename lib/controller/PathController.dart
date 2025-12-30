import 'package:EyuunApp/components/CharacterPath.dart';
import 'package:EyuunApp/components/feature/PathFeature.dart';
import 'package:oxygen/oxygen.dart';

import '../core/registerServices.dart';

class PathController {
  late CharacterPathComponent _characterPathComponent;
  late PathFeatureComponent _pathFeature;

  PathController(CharacterPathComponent characterPath) {
    _pathFeature = locator<PathFeatureComponent>();
  }

  bool isStepPicked(String id) => true;

  bool canPickStep(String id) => true;

  void pickStep(String id) => UnimplementedError();

  bool canPickNewPath(String id) => true;

  void pickNewPath(String id) => UnimplementedError();

  List<Entity> getPickableAdditionalPaths() => [];
}