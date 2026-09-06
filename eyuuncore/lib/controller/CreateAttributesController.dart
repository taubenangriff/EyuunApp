import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';

class CreateAttributesController {
  late AttributesComponent _attributes;

  CreateAttributesController(AttributesComponent attributes) {
    _attributes = attributes;
  }

  /// Sets the dice for the Attribute with [statId] to [dice] while adhering to all rules.
  ///
  /// Throws an [Exception] if setting [statId] to this [dice] is against the rules.
  void setDice(String statId, Dice dice) {
    _attributes.setStatEntry(statId, dice);
    locator<EventBus>().fire(
      EntityUpdatedEvent(locator<CharacterService>().character, _attributes),
    );
  }

  /// Gets whether the stat can be currently set to [dice].
  bool canSet(String statId, Dice dice) {
    var entry = _attributes.getStatEntry(statId);
    if (entry == null) {
      return false;
    }

    if (entry.dice.getUpgrades() > dice.getUpgrades()) {
      return true;
    }

    return dice.getUpgrades() - entry.dice.getUpgrades() <=
        getRemainingDiceUpgrades();
  }

  /// Gets the list of dices that it is possible to set [statId] to while adhering to character creation rules.
  List<Dice> getPossibleDices(String statId) => [Dice.d4, Dice.d6, Dice.d8];

  int getRemainingDiceUpgrades() =>
      _attributes.maxDiceIncreases.current - _attributes.spentUpgrades;
}
