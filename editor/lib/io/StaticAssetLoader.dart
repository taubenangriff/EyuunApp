import 'package:editor/Asset.dart';
import 'package:eyuuncore/core/repository/ComponentRepository.dart';

class StaticAssetLoader {

  ComponentRepository componentRepository;

  StaticAssetLoader(this.componentRepository);

  Map<String, dynamic> toMap(Asset asset) {
    var map = <String, dynamic>{};

    for(var entry in asset.components.entries){
      var key = entry.key;
      var submap = componentRepository.toMap(entry.value);
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
          asset.components[key] = comp;
        }
      }
    }
    return asset;
  }
}