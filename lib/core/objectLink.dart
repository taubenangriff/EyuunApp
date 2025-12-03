import 'package:dart_mappable/dart_mappable.dart';
import 'package:flexbackend/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

part 'objectLink.mapper.dart';

@MappableClass()
class ObjectLink with ObjectLinkMappable {
  String objectId;

  ObjectLink(this.objectId);

  Entity getEntity() => throw UnimplementedError();

  static ObjectLink fromEntity(Entity e) => ObjectLink(e.getObjectId());
}