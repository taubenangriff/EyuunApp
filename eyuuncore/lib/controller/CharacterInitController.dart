import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/components/health.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';

class CharacterInitController {
  CharacterBaseComponent characterBaseComponent;
  HealthComponent? healthComponent;
  FluxComponent? fluxComponent;

  CharacterInitController({
    required this.characterBaseComponent,
    this.healthComponent,
    this.fluxComponent,
  });

  void initCharacter() {
    healthComponent?.hitpoints = healthComponent?.maxHitpoints.current ?? 0;
    fluxComponent?.fluxCapacity =
        (fluxComponent?.fluxMaximum.current ?? 0).upgradable;
    characterBaseComponent.level = 1;
  }
}
