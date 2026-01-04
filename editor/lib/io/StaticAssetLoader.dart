import 'package:editor/Asset.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';

class StaticAssetLoader {

  ComponentRepository componentRepository;

  StaticAssetLoader(this.componentRepository);

  Map<String, dynamic> toMap(Asset asset) {
    var map = <String, dynamic>{};

    for(var comp in asset.components){
      var key = componentRepository.getKey(comp.runtimeType);
      if(key == null) {
        continue;
      }

      var submap = componentRepository.toMap(comp);
      map[key] = submap;
    }

    return map;
  }

  Asset loadAsset(Map<String, dynamic> jsonMap) {
    var asset = Asset();

    for(var key in jsonMap.keys){
      if(componentRepository.isComponent(key)){
        var submap = jsonMap[key];

        var comp = componentRepository.fromMap(key, submap);
        if(comp != null)
        {
          asset.components.add(comp);
        }
      }
    }
    return asset;
  }
}