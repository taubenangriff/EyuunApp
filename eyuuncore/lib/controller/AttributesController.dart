import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/enums/dice.dart';

class AttributesController {
  late AttributesComponent _attributes;

  AttributesController(AttributesComponent attributes) {
    _attributes = attributes;
  }

  /// Sets the dice for the Attribute with [statId] to [dice] while adhering to all rules.
  ///
  /// Throws an [Exception] if setting [statId] to this [dice] is against the rules.
  void setDice(String statId, Dice dice) =>
      _attributes.setStatEntry(statId, dice);

  /// Sets the dice for the attribute with [statId] to [dice] while disregarding all rules.
  /// Throws an [ArgumentError] if the attribute does not exist.
  void setDiceGodmode(String statId, Dice dice) {
    final entry = _attributes.getStatEntry(statId);
    if (entry == null) {
      throw ArgumentError.value(statId, 'statId', 'Unknown attribute');
    }
    entry.dice = dice;
  }

  /// Increases the dice of [statId]. Throws an [Exception] if that is against the rules.
  void increaseOneStep(String statId) {
    final entry = _attributes.getStatEntry(statId);
    if (entry == null) {
      throw ArgumentError.value(statId, 'statId', 'Unknown attribute');
    }
    if (!upgradesPossible(statId)) {
      throw StateError('Cannot upgrade attribute $statId');
    }
    entry.dice = Dice.values[entry.dice.index + 1];
  }

  /// Gets the list of dices that it is possible to set [statId] to while adhering to character creation rules.
  List<Dice> getPossibleDicesAtCharCreation(String statId) => [
    Dice.d4,
    Dice.d6,
    Dice.d8,
  ];

  /// Gets whether the stat can be currently set to [dice].
  bool canSet(String statId, Dice dice) => false;

  /// returns whether it is possible to upgrade the Attribute [statId].
  bool upgradesPossible(String statId) {
    var entry = _attributes.getStatEntry(statId);
    if (entry == null) return false;
    if (entry.dice.getUpgrades() >= Dice.d12.getUpgrades()) return false;
    return _attributes.getUsedDiceUpgrades() <
        _attributes.maxDiceIncreases.current;
  }
}
