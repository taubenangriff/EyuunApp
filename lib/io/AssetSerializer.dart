import 'package:oxygen/oxygen.dart';

import 'WorldManager.dart';

class AssetSerializer{

  WorldManager worldManager;
  AssetSerializer(this.worldManager);

  Map<String, dynamic> serialize(Entity entity) {

    var entityMap = <String, dynamic>{};
    var componentTypes = worldManager.allComponentTypes();

    //We are going through all registered component Types, because there is no way to fetch just the components an Entity has by default.
    //Dumb design on oxygens part.
    //But this works forever as long as Components define their own persistance logic.
    for(var componentType in componentTypes) {
      if(worldManager.entityHasComponent(componentType, entity)){
        var component = worldManager.getComponentFromEntity(componentType, entity);
        var submap = component!.persist();
        entityMap[component!.getName()] = submap;
      }
    }

    return entityMap;
  }
}