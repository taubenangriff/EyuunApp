import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/events/EntityDeletedEvent.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';

class EntityDeletedListener {
  late final StreamSubscription<EntityDeletedEvent> _entityDeletedSubscription;

  EntityDeletedListener() {
    _entityDeletedSubscription =
        locator<EventBus>().on<EntityDeletedEvent>().listen(_onEntityDeleted);
  }

  void _onEntityDeleted(EntityDeletedEvent event) {
    locator<DatabaseAccess>().deleteGameObject(
      locator<SessionService>().sessionId,
      event.objectId,
    );
  }

  Future<void> dispose() => _entityDeletedSubscription.cancel();
}
