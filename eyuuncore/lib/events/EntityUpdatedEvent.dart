import 'package:eyuuncore/core/components/EyuunComponent.dart';
import 'package:oxygen/oxygen.dart';

class EntityUpdatedEvent<T extends EyuunComponent> {
  Entity entity;
  T component;
  EntityUpdatedEvent(this.entity, this.component);
}
