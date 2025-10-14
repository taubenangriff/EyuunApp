import 'EyuunComponent.dart';

class HealthComponent extends EyuunComponent<int> {
  static const int DEFAULT_HITPOINTS = 0;
  static const int DEFAULT_MAX_HITPOINTS = 1;
  static const int DEFAULT_SHIELD = 0;
  static const int DEFAULT_MAX_SHIELD = 1;
  static const int DEFAULT_DEATH_THROWS = 0;
  static const int DEFAULT_MAX_DEATH_THROWS = 1;

  static const String propertyName = "health";

  late int hitpoints;
  late int maxHitpoints;

  late int shield;
  late int maxShield;

  late int deathThrows;
  late int maxDeathThrows;

  @override
  void init([data]) {
    reset();
  }

  @override
  void reset() {
    hitpoints = DEFAULT_MAX_HITPOINTS;
    maxHitpoints = DEFAULT_MAX_HITPOINTS;
    shield = DEFAULT_SHIELD;
    maxShield = DEFAULT_MAX_SHIELD;
    deathThrows = DEFAULT_DEATH_THROWS;
    maxDeathThrows = DEFAULT_MAX_DEATH_THROWS;
  }

  bool isInDyingState() => hitpoints <= 0;

  /* Serialization code to persist certain values that are unique to an entity rather than the asset type.
   *
   * Although honestly, this is just boilerplate that should be done by an external serializer instead.
   * Unfortunately, flutter + reflection with dart:mirrors doesn't work.
   *
   */
  @override
  Map<String, dynamic> persist() {
    return {
      'hitpoints': hitpoints,
      'shield': shield,
      'deathThrows':deathThrows
    };
  }

  @override
  void applyValues(Map<String, dynamic> valueMap){
    hitpoints = valueMap['hitpoints'];
    shield = valueMap['shield'];
    deathThrows = valueMap['deathThrows'];
  }

  @override
  String getName() => propertyName;
}