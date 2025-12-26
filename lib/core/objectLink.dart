import 'package:dart_mappable/dart_mappable.dart';
import 'package:EyuunApp/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

part 'objectLink.mapper.dart';

@MappableClass()
class ObjectLink with ObjectLinkMappable {
  String objectId;

  ObjectLink(this.objectId);

  Entity getEntity() => throw UnimplementedError();

  static ObjectLink fromEntity(Entity e) => ObjectLink(e.getObjectId());
}

extension GetObjectLinkListObjects on Iterable<ObjectLink> {
  getObjects() => map((ObjectLink e) => e.getEntity()).where((e) => e != null).toList();
}