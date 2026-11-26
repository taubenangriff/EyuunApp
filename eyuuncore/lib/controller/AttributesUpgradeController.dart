import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attribute.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/controller/AttributesController.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

/// Manages a temporary set of attribute upgrades until they are accepted.
class AttributesUpgradeController {
  final Entity _character;
  final AttributesComponent _attributes;
  late final AttributesController _controller = AttributesController(
    _attributes,
  );
  AttributesComponent? _draft;
  List<AttributeEntry>? _originalEntries;
  List<Dice>? _originalDice;

  AttributesUpgradeController(this._character)
    : _attributes =
          _character.get<AttributesComponent>() ??
          (throw StateError('Character has no attributes'));

  bool get isEditing => _draft != null;

  bool get hasPendingChanges {
    final draft = _draft;
    if (draft == null) return false;
    for (var i = 0; i < draft.statValues.length; i++) {
      if (draft.statValues[i].dice != _originalDice![i]) return true;
    }
    return false;
  }

  List<AttributeEntry> get statValues =>
      List.unmodifiable((_draft ?? _attributes).statValues);

  bool canIncrease(String statId) {
    final draft = _draft;
    if (draft == null) return _controller.upgradesPossible(statId);
    draft.maxDiceIncreases = _attributes.maxDiceIncreases;
    return AttributesController(draft).upgradesPossible(statId);
  }

  bool canDecrease(String statId) {
    if (_draft == null) return false;
    final index = _draft!.statValues.indexWhere(
      (entry) => entry.stat.getTypeId() == statId,
    );
    return index >= 0 &&
        _draft!.statValues[index].dice.index > _originalDice![index].index;
  }

  void increase(String statId) {
    if (!canIncrease(statId)) {
      throw StateError('Cannot upgrade attribute $statId');
    }
    if (_draft == null) {
      _originalEntries = List.of(_attributes.statValues);
      _originalDice = _originalEntries!.map((entry) => entry.dice).toList();
      _draft = AttributesComponent()
        ..statValues = _originalEntries!
            .map((entry) => AttributeEntry(entry.stat, entry.dice))
            .toList()
        ..maxDiceIncreases = _attributes.maxDiceIncreases;
    }
    AttributesController(_draft!).increaseOneStep(statId);
  }

  void decrease(String statId) {
    if (!canDecrease(statId)) {
      throw StateError('Cannot decrease attribute $statId');
    }
    final entry = _draft!.getStatEntry(statId)!;
    entry.dice = Dice.values[entry.dice.index - 1];
    if (!hasPendingChanges) cancel();
  }

  /// Applies the draft only if the underlying attributes and budget are unchanged
  /// enough to make it valid.
  void accept() {
    final draft = _draft;
    if (draft == null) throw StateError('No attribute upgrades to accept');

    final originalEntries = _originalEntries!;
    final originalDice = _originalDice!;
    if (_attributes.statValues.length != originalEntries.length) {
      throw StateError(
        'Attributes changed while editing; cancel and try again',
      );
    }
    for (var i = 0; i < originalEntries.length; i++) {
      if (!identical(_attributes.statValues[i], originalEntries[i]) ||
          originalEntries[i].dice != originalDice[i]) {
        throw StateError(
          'Attributes changed while editing; cancel and try again',
        );
      }
    }

    final changed = List.generate(
      originalEntries.length,
      (i) => draft.statValues[i].dice != originalDice[i],
    );
    if (!changed.contains(true)) {
      cancel();
      return;
    }
    if (draft.getUsedDiceUpgrades() > _attributes.maxDiceIncreases.current) {
      throw StateError('Not enough dice upgrades; adjust or cancel your edits');
    }

    final eventBus = locator<EventBus>();
    final upgradable = _character.get<UpgradableComponent>();
    for (var i = 0; i < originalEntries.length; i++) {
      if (!changed[i]) continue;
      final steps =
          draft.statValues[i].dice.getUpgrades() -
          originalDice[i].getUpgrades();
      originalEntries[i].dice = draft.statValues[i].dice;
      final buff = originalEntries[i].stat
          .get<AttributeComponent>()
          ?.buffWhenUpgraded;
      if (upgradable == null || buff == null) continue;
      for (var step = 0; step < steps; step++) {
        upgradable.applyUpgrade(buff);
      }
    }
    cancel();
    eventBus.fire(EntityUpdatedEvent(_character, _attributes));
    if (upgradable != null) {
      eventBus.fire(EntityUpdatedEvent(_character, upgradable));
      if (locator.isRegistered<WorldManager>()) {
        locator<WorldManager>().execute();
      }
    }
  }

  void cancel() {
    _draft = null;
    _originalEntries = null;
    _originalDice = null;
  }
}
