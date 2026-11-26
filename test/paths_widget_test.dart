import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/view/widgets/cards/PathsWidget.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/CharacterPath.dart';
import 'package:eyuuncore/components/feature/LevelFeature.dart';
import 'package:eyuuncore/components/feature/PathFeature.dart';
import 'package:eyuuncore/components/upgradable.dart';
import 'package:eyuuncore/components/upgrade/CharacterPathUpgrade.dart';
import 'package:eyuuncore/controller/LevelController.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/core/services/WorldManager.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:eyuuncore/system/upgradeSystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('refreshes paths when the character receives a level upgrade', (
    tester,
  ) async {
    final events = EventBus();
    final world = WorldManager();
    locator.registerSingleton<EventBus>(events);
    locator.registerSingleton<WorldManager>(world);
    locator.registerSingleton<PathFeatureComponent>(PathFeatureComponent());
    final characterService = CharacterService();
    locator.registerSingleton<CharacterService>(characterService);

    world.registerComponent<CharacterBaseComponent, int>(
      CharacterBaseComponent.propertyName,
      CharacterBaseComponent.new,
    );
    world.registerComponent<CharacterPathComponent, int>(
      CharacterPathComponent.propertyName,
      CharacterPathComponent.new,
    );
    world.registerComponent<UpgradableComponent, int>(
      UpgradableComponent.propertyName,
      UpgradableComponent.new,
    );
    world.registerComponent<CharacterPathUpgradeComponent, int>(
      CharacterPathUpgradeComponent.propertyName,
      CharacterPathUpgradeComponent.new,
    );
    world.registerUpgrade(
      (component) => (component as CharacterPathComponent).pathCapacity,
      (component) =>
          (component as CharacterPathUpgradeComponent).pathCapacityUpgrade,
      CharacterPathComponent.propertyName,
      CharacterPathUpgradeComponent.propertyName,
    );
    world.world.registerSystem(UpgradeSystem());
    world.init();

    final character = world.world.createEntity()
      ..add<CharacterBaseComponent, int>()
      ..add<CharacterPathComponent, int>()
      ..add<UpgradableComponent, int>();
    characterService.changeCharacter(character);
    final paths = character.get<CharacterPathComponent>()!;
    final upgrade = world.staticWorld.createEntity()
      ..add<CharacterPathUpgradeComponent, int>();
    upgrade.get<CharacterPathUpgradeComponent>()!.pathCapacityUpgrade = 1;
    locator.registerSingleton<LevelFeatureComponent>(
      LevelFeatureComponent()..levels = [upgrade],
    );

    addTearDown(() {
      events.destroy();
      locator.unregister<LevelFeatureComponent>();
      locator.unregister<CharacterService>();
      locator.unregister<PathFeatureComponent>();
      locator.unregister<WorldManager>();
      locator.unregister<EventBus>();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: PathsWidget()),
        ),
      ),
    );
    expect(find.text("'+ Add new Path'"), findsNothing);

    final otherCharacter = world.world.createEntity();
    paths.pathCapacity.base = 1;
    events.fire(EntityUpdatedEvent(otherCharacter, paths));
    await tester.pump();
    expect(find.text("'+ Add new Path'"), findsNothing);
    paths.pathCapacity.base = 0;

    LevelController(character).levelup();
    expect(paths.pathCapacity.current, 1);
    await tester.pump();
    expect(find.text("'+ Add new Path'"), findsOneWidget);

    paths.pathCapacity.upgrade = 0;
    events.fire(EntityUpdatedEvent(character, paths));
    await tester.pump();
    expect(find.text("'+ Add new Path'"), findsNothing);

    await tester.pumpWidget(const SizedBox());
    events.fire(EntityUpdatedEvent(character, paths));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
