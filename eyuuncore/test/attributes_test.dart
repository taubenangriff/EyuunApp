import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attribute.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/controller/AttributesController.dart';
import 'package:eyuuncore/controller/AttributesUpgradeController.dart';
import 'package:eyuuncore/core/components/standard.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oxygen/oxygen.dart';

void main() {
  test('counts dice upgrades across attributes', () {
    final attributes = AttributesComponent()..reset();
    final world = World();

    expect(attributes.getUsedDiceUpgrades(), 0);

    attributes.statValues = Dice.values
        .map((dice) => AttributeEntry(world.createEntity(), dice))
        .toList();

    expect(attributes.getUsedDiceUpgrades(), 21);

    attributes.statValues[1].dice = Dice.d8;
    expect(attributes.getUsedDiceUpgrades(), 23);
  });

  group('AttributesController', () {
    late AttributesComponent attributes;
    late AttributesController controller;
    late AttributeEntry entry;
    late EventBus eventBus;
    late List<EntityUpdatedEvent> events;

    setUp(() {
      final world = World()
        ..registerComponent(() => StandardComponent())
        ..registerComponent(() => AttributesComponent());
      final character = world.createEntity()..add<AttributesComponent, int>();
      final stat = world.createEntity();
      stat.add<StandardComponent, String>();
      stat.get<StandardComponent>()!.typeId = 'strength';
      entry = AttributeEntry(stat, Dice.d4);
      attributes = character.get<AttributesComponent>()!
        ..statValues = [entry]
        ..maxDiceIncreases = 4.upgradable;
      eventBus = EventBus(sync: true);
      locator.registerSingleton<EventBus>(eventBus);
      events = [];
      eventBus.on<EntityUpdatedEvent>().listen(events.add);
      controller = AttributesController(character);
    });

    tearDown(() {
      eventBus.destroy();
      locator.unregister<EventBus>();
    });

    test('fires an update event when changing dice', () {
      controller.increaseOneStep('strength');
      controller.setDiceGodmode('strength', Dice.d12);
      expect(events.length, 2);
      expect(events.every((e) => e.component == attributes), isTrue);
    });

    test('godmode sets any die regardless of the budget and limit', () {
      attributes.maxDiceIncreases = 0.upgradable;
      controller.setDiceGodmode('strength', Dice.d100);
      expect(entry.dice, Dice.d100);
      controller.setDiceGodmode('strength', Dice.d2);
      expect(entry.dice, Dice.d2);
      expect(
        () => controller.setDiceGodmode('missing', Dice.d6),
        throwsArgumentError,
      );
    });

    test('increases one step at a time up to the d12 limit', () {
      for (final dice in [Dice.d6, Dice.d8, Dice.d10, Dice.d12]) {
        controller.increaseOneStep('strength');
        expect(entry.dice, dice);
      }
      attributes.maxDiceIncreases = 10.upgradable;
      expect(() => controller.increaseOneStep('strength'), throwsStateError);
      expect(entry.dice, Dice.d12);
    });

    test('rejects upgrades without budget or for a missing attribute', () {
      attributes.maxDiceIncreases = 0.upgradable;
      expect(() => controller.increaseOneStep('strength'), throwsStateError);
      expect(entry.dice, Dice.d4);
      expect(() => controller.increaseOneStep('missing'), throwsArgumentError);
    });
  });

  group('AttributesUpgradeController', () {
    late World world;
    late Entity character;
    late AttributesComponent attributes;
    late AttributesUpgradeController controller;
    late EventBus eventBus;
    late List<EntityUpdatedEvent> events;

    setUp(() {
      world = World()
        ..registerComponent(() => StandardComponent())
        ..registerComponent(() => AttributesComponent());
      character = world.createEntity();
      character.add<AttributesComponent, int>();
      attributes = character.get<AttributesComponent>()!;
      attributes.maxDiceIncreases = 4.upgradable;
      for (final (id, dice) in [('strength', Dice.d4), ('agility', Dice.d8)]) {
        final stat = world.createEntity();
        stat.add<StandardComponent, String>();
        stat.get<StandardComponent>()!.typeId = id;
        attributes.statValues.add(AttributeEntry(stat, dice));
      }
      eventBus = EventBus(sync: true);
      locator.registerSingleton<EventBus>(eventBus);
      events = [];
      eventBus.on<EntityUpdatedEvent>().listen(events.add);
      controller = AttributesUpgradeController(character);
    });

    tearDown(() {
      eventBus.destroy();
      locator.unregister<EventBus>();
    });

    test('stages and redistributes upgrades before accepting once', () {
      expect(controller.canDecrease('agility'), isFalse);
      controller.increase('strength');
      controller.increase('agility');
      expect(controller.canIncrease('strength'), isFalse);
      expect(controller.canIncrease('agility'), isFalse);
      expect(attributes.statValues.map((e) => e.dice), [Dice.d4, Dice.d8]);
      expect(controller.statValues.map((e) => e.dice), [Dice.d6, Dice.d10]);
      expect(events, isEmpty);

      controller.decrease('agility');
      expect(controller.canDecrease('agility'), isFalse);
      expect(() => controller.decrease('agility'), throwsStateError);
      controller.increase('strength');
      controller.accept();

      expect(attributes.statValues.map((e) => e.dice), [Dice.d8, Dice.d8]);
      expect(controller.isEditing, isFalse);
      expect(events, hasLength(1));
      expect(events.single.entity, same(character));
      expect(events.single.component, same(attributes));

      attributes.maxDiceIncreases = 5.upgradable;
      controller.increase('strength');
      controller.decrease('strength');
      expect(controller.canDecrease('strength'), isFalse);
      expect(controller.isEditing, isFalse);
      expect(events, hasLength(1));
    });

    test('applies the buffs once per upgrade step on accept', () {
      world
        ..registerComponent(() => UpgradableComponent())
        ..registerComponent(() => AttributeComponent());
      character.add<UpgradableComponent, int>();
      final buff = world.createEntity();
      final strength = attributes.statValues.first.stat
        ..add<AttributeComponent, int>();
      strength.get<AttributeComponent>()!.buffWhenUpgraded = buff;

      controller.increase('strength');
      controller.increase('strength');
      controller.accept();

      final applied = character.get<UpgradableComponent>()!.appliedUpgrades;
      expect(applied, hasLength(2));
      expect(applied, everyElement(same(buff)));
      expect(events.map((e) => e.component), [
        same(attributes),
        same(character.get<UpgradableComponent>()),
      ]);
    });

    test('enforces the d12 cap and discards cancelled edits', () {
      attributes.maxDiceIncreases = 20.upgradable;
      controller.increase('strength');
      controller.increase('strength');
      controller.increase('strength');
      controller.increase('strength');
      expect(controller.statValues.first.dice, Dice.d12);
      expect(controller.canIncrease('strength'), isFalse);
      expect(() => controller.increase('strength'), throwsStateError);
      controller.cancel();
      expect(attributes.statValues.first.dice, Dice.d4);
      expect(controller.isEditing, isFalse);
      expect(events, isEmpty);
    });

    test('rejects stale drafts or an insufficient changed budget', () {
      controller.increase('strength');
      attributes.statValues.first.dice = Dice.d6;
      expect(controller.accept, throwsStateError);
      expect(attributes.statValues.map((e) => e.dice), [Dice.d6, Dice.d8]);
      expect(events, isEmpty);

      controller.cancel();
      attributes.statValues.first.dice = Dice.d4;
      controller.increase('strength');
      attributes.maxDiceIncreases = 2.upgradable;
      expect(controller.canIncrease('strength'), isFalse);
      expect(controller.accept, throwsStateError);
      expect(attributes.statValues.first.dice, Dice.d4);
      expect(events, isEmpty);
      controller.decrease('strength');
      expect(controller.isEditing, isFalse);
    });
  });
}
