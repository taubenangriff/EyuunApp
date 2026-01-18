import 'package:eyuuncore/core/components/EntityExtensions.dart';
import 'package:oxygen/oxygen.dart';

class GameObjectRepository {
  Map<String, Entity> _entities = {};

  void preregisterEntity(Entity e, String objectId){
    _entities[objectId] = e;
  }

  void registerEntity(Entity e) {
    var objectId = e.getObjectId();
    _entities[objectId] = e;
  }

  void removeEntity(Entity e) {
    var objectId = e.getObjectId();
    _entities.remove(objectId);
  }

  Entity? getEntity(String objectId) => _entities[objectId];

  List<Entity> getEntities() => _entities.values.toList();
}