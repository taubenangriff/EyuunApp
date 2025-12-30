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

  bool canPick(String id) => true;

  bool isPicked(String id) => true;

  void pickStep(String id) => UnimplementedError();

  void pickNewPath(String id) => UnimplementedError();

  bool canPickNewPath(String id) => true;
}