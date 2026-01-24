import 'package:eyuuncore/components/feature/DeathFeature.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/enums/AliveState.dart';
import 'package:oxygen/oxygen.dart';
import '../GetIt.dart';

class DyingStateController {
  Entity dyingEntity;
  DeathFeatureComponent deathFeature = locator<DeathFeatureComponent>();

  DyingStateController(this.dyingEntity);

  bool isStabilized() {
    return dyingEntity.get<HealthComponent>()?.aliveState == AliveState.Stabilized;
  }

  bool isDying() {
    return dyingEntity.get<HealthComponent>()?.aliveState == AliveState.Dying;
  }

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

  void stabilize() {
    UnimplementedError();
  }

  void startDying() {
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