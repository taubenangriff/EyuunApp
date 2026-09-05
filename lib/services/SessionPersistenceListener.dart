import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:eyuuncore/events/SessionCreatedEvent.dart';
import 'package:eyuuncore/io/SessionData.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';

class SessionPersistenceListener {
  late final StreamSubscription<SessionCreatedEvent>
      _sessionCreatedSubscription;

  SessionPersistenceListener() {
    _sessionCreatedSubscription = locator<EventBus>()
        .on<SessionCreatedEvent>()
        .listen(_persistCreatedSession);
  }

  Future<void> _persistCreatedSession(SessionCreatedEvent event) async {
    print(event.sessionId);
    final entities = locator<GameObjectService>().getObjects();
    final sessionData = SessionData(
      event.character.getObjectId(),
      event.sessionId,
      entities.map((entity) => entity.getObjectId()).toList(),
    );
    final databaseAccess = locator<DatabaseAccess>();

    await databaseAccess.postSessionData(event.sessionId, sessionData);
    await Future.wait(
      entities.map(
        (entity) => databaseAccess.postGameObject(
          event.sessionId,
          entity.getObjectId(),
          entity,
        ),
      ),
    );
  }

  Future<void> dispose() => _sessionCreatedSubscription.cancel();
}
