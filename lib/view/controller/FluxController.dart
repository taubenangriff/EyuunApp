import 'package:event_bus/event_bus.dart';
import 'package:eyuunapp/view/controller/ChangeValueController.dart';
import 'package:eyuuncore/GetIt.dart';
import 'package:eyuuncore/components/Flux.dart';
import 'package:eyuuncore/events/EntityUpdatedEvent.dart';
import 'package:oxygen/oxygen.dart';

/// Bundles the controllers for the current flux and the flux capacity of an entity.
class FluxController {
  late final ChangeValueController currentFluxController;
  late final ChangeValueController fluxCapacityController;

  late final Entity entity;

  /// Throws an [ArgumentError] if [entity] has no [FluxComponent].
  FluxController(Entity entity) {
    this.entity = entity;
    final flux = entity.get<FluxComponent>();
    if (flux == null) {
      throw ArgumentError.value(
          entity, 'entity', 'Entity has no FluxComponent');
    }

    currentFluxController = ChangeValueController(
      flux.fluxSpent,
      maxLimit: flux.fluxCapacity.current,
      minLimit: 0,
      onValUpdated: (val) => flux.fluxSpent = val,
    );
    fluxCapacityController = ChangeValueController(
      flux.fluxCapacity.current,
      maxLimit: flux.fluxMaximum.current,
      minLimit: 0,
      onValUpdated: (val) =>
          flux.fluxCapacity.base = val - flux.fluxCapacity.upgrade,
    );
  }

  void accept() {
    locator<EventBus>()
        .fire(EntityUpdatedEvent(entity, entity.get<FluxComponent>()!));
  }
}
