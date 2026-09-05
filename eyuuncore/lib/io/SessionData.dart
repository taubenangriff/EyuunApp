import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'SessionData.mapper.dart';

@MappableClass()
class SessionData with SessionDataMappable {
  String characterId;
  String sessionId;
  List<String> gameObjects;
  SessionData(this.characterId, this.sessionId, this.gameObjects);

  static const uuid = Uuid();
  static SessionData empty() => SessionData("", uuid.v4(), []);
}
