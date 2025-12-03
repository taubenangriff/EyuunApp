import 'package:dart_mappable/dart_mappable.dart';

part 'objectLink.mapper.dart';

@MappableClass()
class ObjectLink with ObjectLinkMappable {
  String objectId;

  ObjectLink(this.objectId);
}