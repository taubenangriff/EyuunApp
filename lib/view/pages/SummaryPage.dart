import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/pages/MainPage.dart';
import 'package:eyuunapp/view/widgets/EyuunWidgets.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/enums/CharacterState.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:eyuuncore/events/SessionCreatedEvent.dart';
import 'package:eyuuncore/events/SessionLoadEvent.dart';
import 'package:eyuuncore/events/SessionLoadedEvent.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final VoidCallback onCharacterCreated;

  const SummaryPage({super.key, required this.onCharacterCreated});

  void _createCharacter(BuildContext context) {
    final character = locator<CharacterService>().character;
    final characterBase = character.get<CharacterBaseComponent>()!;
    final sessionService = locator<SessionService>();

    characterBase.characterState = CharacterState.Ingame;
    locator<EventBus>().fire(EntityUpdatedEvent(character, characterBase));
    locator<EventBus>()
        .fire(SessionCreatedEvent(sessionService.sessionId, character));
    locator<EventBus>().fire(SessionLoadEvent(sessionService.sessionId));
    locator<EventBus>()
        .fire(SessionLoadedEvent(sessionService.sessionId, character));

    onCharacterCreated();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainPage(title: 'Eyuun App')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EyuunWidgets.floatingActionButton(
        text: 'Create',
        width: 300,
        height: 50,
        onPressed: () => _createCharacter(context),
      ),
    );
  }
}
