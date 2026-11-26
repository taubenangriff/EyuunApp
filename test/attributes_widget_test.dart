import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/view/widgets/DiceIcon.dart';
import 'package:eyuunapp/view/widgets/cards/AttributesWidget.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Attributes.dart';
import 'package:eyuuncore/controller/AttributesUpgradeController.dart';
import 'package:eyuuncore/core/components/standard.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/TextService.dart';
import 'package:eyuuncore/core/upgrading/UpgradableInt.dart';
import 'package:eyuuncore/enums/dice.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oxygen/oxygen.dart';

class _TextService implements TextService {
  @override
  String getText(String textLookup, {List<String> formatArgs = const []}) =>
      textLookup;

  @override
  String getTextFromEntity(Entity? entity,
          {List<String> formatArgs = const []}) =>
      'Strength';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('shows actions for pending edits and commits only on accept', (
    tester,
  ) async {
    final world = World()
      ..registerComponent(() => StandardComponent())
      ..registerComponent(() => AttributesComponent());
    final character = world.createEntity()..add<AttributesComponent, int>();
    final attributes = character.get<AttributesComponent>()!;
    final stat = world.createEntity()..add<StandardComponent, String>();
    stat.get<StandardComponent>()!.typeId = 'strength';
    attributes
      ..statValues = [AttributeEntry(stat, Dice.d4)]
      ..maxDiceIncreases = 2.upgradable;
    final controller = AttributesUpgradeController(character);
    locator.registerSingleton<TextService>(_TextService());
    final characterService = CharacterService()..changeCharacter(character);
    locator.registerSingleton<CharacterService>(characterService);
    final eventBus = EventBus(sync: true);
    locator.registerSingleton<EventBus>(eventBus);
    final events = <EntityUpdatedEvent>[];
    eventBus.on<EntityUpdatedEvent>().listen(events.add);
    addTearDown(() {
      eventBus.destroy();
      locator.unregister<EventBus>();
      locator.unregister<TextService>();
      locator.unregister<CharacterService>();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AttributesWidget(controller: controller),
        ),
      ),
    );

    expect(tester.widget<DiceIcon>(find.byType(DiceIcon)).type, Dice.d4);
    expect(find.byIcon(Icons.keyboard_arrow_left_rounded), findsNothing);
    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
    await tester.tap(find.byIcon(Icons.keyboard_arrow_right_rounded));
    await tester.pump();

    expect(tester.widget<DiceIcon>(find.byType(DiceIcon)).type, Dice.d6);
    expect(attributes.statValues.single.dice, Dice.d4);
    expect(
      tester.getCenter(find.byIcon(Icons.keyboard_arrow_left_rounded)).dx,
      lessThan(tester.getCenter(find.byType(DiceIcon)).dx),
    );
    expect(
      tester.getCenter(find.byIcon(Icons.keyboard_arrow_right_rounded)).dx,
      greaterThan(tester.getCenter(find.byType(DiceIcon)).dx),
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(events, isEmpty);
    await tester.tap(find.byIcon(Icons.keyboard_arrow_left_rounded));
    await tester.pump();
    expect(tester.widget<DiceIcon>(find.byType(DiceIcon)).type, Dice.d4);
    expect(find.byIcon(Icons.keyboard_arrow_left_rounded), findsNothing);
    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
    expect(attributes.statValues.single.dice, Dice.d4);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_right_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(attributes.statValues.single.dice, Dice.d4);
    expect(find.byIcon(Icons.check), findsNothing);
    expect(events, isEmpty);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_right_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    expect(attributes.statValues.single.dice, Dice.d6);
    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
    expect(events, hasLength(1));

    attributes.statValues.single.dice = Dice.d8;
    eventBus.fire(EntityUpdatedEvent(character, attributes));
    await tester.pump();
    expect(tester.widget<DiceIcon>(find.byType(DiceIcon)).type, Dice.d8);
  });
}
