import 'dart:math';

import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/enums/dice.dart';

class AttributesController{

  late AttributesComponent _attributes;

  AttributesController(AttributesComponent attributes){
    _attributes = attributes;
  }

  /// Sets the dice for the Attribute with [statId] to [dice] while adhering to all rules.
  ///
  /// Throws an [Exception] if setting [statId] to this [dice] is against the rules.
  void setDice(String statId, Dice dice) => throw UnimplementedError();

  /// Sets the dice for the attribute with [statId] to [dice] while disregarding all rules.
  void setDiceGodmode(String statId, Dice dice) => throw UnimplementedError();

  /// Increases the dice of [statId]. Throws an [Exception] if that is against the rules.
  void increaseOneStep(String statId) => throw UnimplementedError();

  /// Gets the list of dices that it is possible to set [statId] to while adhering to all rules.
  List<Dice> getPossibleDices(String statId) => throw UnimplementedError();

  /// returns whether it is possible to upgrade the Attribute [statId].
  bool upgradesPossible(String statId) => true; //throw UnimplementedError();
}