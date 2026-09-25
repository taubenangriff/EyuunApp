import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';

class EntityUpdatedListener {
  late final StreamSubscription<EntityUpdatedEvent> _entityUpdatedSubscription;

  EntityUpdatedListener() {
    _entityUpdatedSubscription =
        locator<EventBus>().on<EntityUpdatedEvent>().listen(_onEntityUpdated);
  }

  void _onEntityUpdated(EntityUpdatedEvent event) async {
    try {
      await locator<DatabaseAccess>().updateGameObjectComponent(
        locator<SessionService>().sessionId,
        event.entity.getObjectId(),
        event.component,
      );
    } catch (e) {
      PopupUtil.showPopup(e.toString(), header: 'Failed to save changes');
    }
  }

  Future<void> dispose() => _entityUpdatedSubscription.cancel();
}
