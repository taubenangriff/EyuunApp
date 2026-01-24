import 'package:eyuuncore/components/feature/DeathFeature.dart';
import 'package:oxygen/oxygen.dart';

import '../core/registerServices.dart';

class DyingStateController {
  Entity dyingEntity;
  DeathFeatureComponent deathFeature = locator<DeathFeatureComponent>();

  DyingStateController(this.dyingEntity);

  bool passesDeathCheck(int diceResult) {
    UnimplementedError();
    return true;
  }

  void increaseDyingCheck() {
    UnimplementedError();
  }

  void endDyingState() {
    UnimplementedError();
  }

  void tryStabilize(int diceResult) {
    UnimplementedError();
  }

  int getCurrentThreshold() {
    UnimplementedError();
    return 0;
  }

  void die() {
    UnimplementedError();
  }
}