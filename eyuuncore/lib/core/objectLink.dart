import 'package:dart_mappable/dart_mappable.dart';
import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:eyuuncore/core/registerServices.dart';
import 'package:eyuuncore/core/services/GameObjectService.dart';
import 'package:oxygen/oxygen.dart';

part 'objectLink.mapper.dart';

@MappableClass()
class ObjectLink with ObjectLinkMappable {
  String objectId;

  ObjectLink(this.objectId);

  Entity getEntity() => locator<GameObjectService>().getObject(objectId)!;

  static ObjectLink fromEntity(Entity e) => ObjectLink(e.getObjectId());
}

extension GetObjectLinkListObjects on Iterable<ObjectLink> {
  List<Entity> getObjects() => map((ObjectLink e) => e.getEntity()).where((e) => e != null).toList();
}

extension GetEntityListLinks on Iterable<Entity> {
  List<ObjectLink> asObjectLinks() => map((Entity e) => ObjectLink.fromEntity(e)).toList();
}

extension getLinkFromEntity on Entity {
  ObjectLink asObjectLink() => ObjectLink.fromEntity(this);
}