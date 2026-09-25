import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/events/EntityCreatedEvent.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';

class EntityCreatedListener {
  late final StreamSubscription<EntityCreatedEvent> _entityCreatedSubscription;

  EntityCreatedListener() {
    _entityCreatedSubscription =
        locator<EventBus>().on<EntityCreatedEvent>().listen(_onEntityCreated);
  }

  void _onEntityCreated(EntityCreatedEvent event) {
    locator<DatabaseAccess>().postGameObject(
      locator<SessionService>().sessionId,
      event.entity.getObjectId(),
      event.entity,
    );
  }

  Future<void> dispose() => _entityCreatedSubscription.cancel();
}
