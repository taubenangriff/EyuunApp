import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/model/CharacterMetaInfo.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/CharacterBase.dart';
import 'package:eyuuncore/components/Nameable.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/services/CharacterService.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:eyuunapp/services/DatabaseAccess.dart';
import 'package:eyuunapp/services/SessionService.dart';
import 'package:eyuunapp/view/popup/PopupUtil.dart';
import 'package:oxygen/oxygen.dart';

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

    if (event.entity == locator<CharacterService>().character &&
        (event.component is CharacterBaseComponent ||
            event.component is NameableComponent)) {
      updateCharacterMetaInfo(event.entity);
    }
  }

  void updateCharacterMetaInfo(Entity entity) {
    CharacterBaseComponent characterBase =
        entity.get<CharacterBaseComponent>() ?? CharacterBaseComponent();
    NameableComponent nameable =
        entity.get<NameableComponent>() ?? NameableComponent();
    CharacterMetaInfo info = CharacterMetaInfo.fromCharacterBaseComponent(
        characterBase, nameable,
        lastModified: DateTime.now(), creatorName: "");

    locator<DatabaseAccess>().postCharacterMetaInfo(
      locator<SessionService>().sessionId,
      info,
    );
  }

  Future<void> dispose() => _entityUpdatedSubscription.cancel();
}
